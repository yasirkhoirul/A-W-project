import * as logger from "firebase-functions/logger";
import * as MidtransClient from "midtrans-client";
import { PaymentRepository } from "../repositories/payment.repository.js";
import {
    CreateTransactionInput,
    CreateTransactionResponse,
    MidtransNotificationPayload,
} from "../models/payment.model.js";

/**
 * Payment Service
 * Logika bisnis untuk integrasi Midtrans Snap + simpan pesanan
 */
export class PaymentService {
    private readonly snap: MidtransClient.Snap;
    private readonly coreApi: MidtransClient.CoreApi;

    constructor(private readonly paymentRepository: PaymentRepository) {
        const config = {
            isProduction: false,
            serverKey: "serverkey",
            clientKey: "clientkey",
        };

        this.snap = new MidtransClient.Snap(config);
        this.coreApi = new MidtransClient.CoreApi(config);
    }

    /**
     * Buat transaksi Midtrans Snap + simpan pesanan ke Firestore
     *
     * @param {CreateTransactionInput} input Data pesanan dari Flutter
     * @param {string} userId User ID dari auth
     * @return {Promise<CreateTransactionResponse>} Token & redirect URL
     */
    async createTransaction(
        input: CreateTransactionInput,
        userId: string
    ): Promise<CreateTransactionResponse> {
        // Generate unique order ID
        const timestamp = Date.now();
        const random = Math.random().toString(36).substring(2, 8);
        const orderId = `AW-${timestamp}-${random}`;

        // Hitung gross_amount = total harga barang + ongkir
        const grossAmount = input.totalPrice + input.shipping.cost;

        logger.info("Creating Midtrans transaction", {
            orderId,
            grossAmount,
            itemCount: input.items.length,
            shippingCost: input.shipping.cost,
            customerId: userId,
        });

        // Build item_details untuk Midtrans
        const itemDetails = [
            // Produk-produk dari cart
            ...input.items.map((item) => ({
                id: item.id,
                price: item.price,
                quantity: item.quantity,
                name: item.name.substring(0, 50), // Midtrans max 50 char
            })),
            // Ongkir sebagai item tambahan
            {
                id: `SHIPPING-${input.shipping.code}`,
                price: input.shipping.cost,
                quantity: 1,
                name: `Ongkir ${input.shipping.name} ${input.shipping.service}`
                    .substring(0, 50),
            },
        ];

        // Build parameter Midtrans Snap
        const params = {
            transaction_details: {
                order_id: orderId,
                gross_amount: grossAmount,
            },
            item_details: itemDetails,
            customer_details: {
                first_name: input.customer.displayName,
                email: input.customer.email,
                phone: input.customer.phoneNumber,
                shipping_address: {
                    first_name: input.customer.displayName,
                    email: input.customer.email,
                    phone: input.customer.phoneNumber,
                    city: input.customer.city,
                },
            },
        };

        // Hit Midtrans Snap API
        const transaction = await this.snap.createTransaction(params);

        logger.info("Midtrans transaction created, saving to Firestore", {
            orderId,
            token: transaction.token,
        });

        // Simpan pesanan ke Firestore
        await this.paymentRepository.savePesanan(
            orderId,
            input,
            userId,
            transaction.token,
            transaction.redirect_url
        );

        logger.info("Pesanan saved to Firestore", { orderId });

        return {
            token: transaction.token,
            redirectUrl: transaction.redirect_url,
            orderId,
        };
    }

    /**
     * Handle notifikasi webhook dari Midtrans
     * Verifikasi signature + update status pesanan di Firestore
     *
     * @param {MidtransNotificationPayload} notificationJson Body dari webhook
     * @return {Promise<{orderId: string, status: string}>}
     */
    async handleNotification(
        notificationJson: MidtransNotificationPayload
    ): Promise<{ orderId: string; status: string }> {
        // Verifikasi signature menggunakan Midtrans CoreApi
        const statusResponse =
            await this.coreApi.transaction.notification(
                notificationJson as unknown as Record<string, unknown>
            );

        const orderId = statusResponse.order_id;
        const transactionStatus = statusResponse.transaction_status;
        const fraudStatus = statusResponse.fraud_status;
        const paymentType = statusResponse.payment_type;

        logger.info("Midtrans notification received", {
            orderId,
            transactionStatus,
            fraudStatus,
            paymentType,
        });

        // Tentukan status final berdasarkan transaction_status + fraud_status
        let finalStatus: string;

        if (transactionStatus === "capture") {
            // Kartu kredit: cek fraud status
            finalStatus = fraudStatus === "accept" ? "settlement" : "deny";
        } else if (transactionStatus === "settlement") {
            finalStatus = "settlement";
        } else if (transactionStatus === "pending") {
            finalStatus = "pending";
        } else if (transactionStatus === "deny") {
            finalStatus = "deny";
        } else if (transactionStatus === "cancel") {
            finalStatus = "cancel";
        } else if (transactionStatus === "expire") {
            finalStatus = "expire";
        } else {
            finalStatus = "failure";
        }

        // Update status di Firestore
        const updated = await this.paymentRepository.updatePesananStatus(
            orderId,
            finalStatus,
            paymentType
        );

        if (!updated) {
            logger.warn("Pesanan not found for notification", { orderId });
        } else {
            logger.info("Pesanan status updated", {
                orderId,
                finalStatus,
                paymentType,
            });
        }

        return { orderId, status: finalStatus };
    }
}
