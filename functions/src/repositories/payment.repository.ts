import { getFirestore, FieldValue } from "firebase-admin/firestore";
import {
    CreateTransactionInput,
} from "../models/payment.model.js";

/**
 * Pesanan document di Firestore
 */
export interface PesananDocument {
    orderId: string;
    userId: string;
    items: Array<{
        id: string;
        name: string;
        price: number;
        quantity: number;
        subtotal: number;
    }>;
    shipping: {
        name: string;
        code: string;
        service: string;
        description: string;
        cost: number;
        etd: string;
    };
    customer: {
        displayName: string;
        email: string;
        phoneNumber: string;
        city: string;
    };
    totalPrice: number; // Harga barang saja
    shippingCost: number;
    grossAmount: number; // totalPrice + shippingCost
    status: "pending" | "paid" | "shipped" | "completed" | "cancelled";
    midtransToken: string;
    midtransRedirectUrl: string;
    createdAt: FieldValue;
    updatedAt: FieldValue;
}

/**
 * Payment Repository
 * Urusan database (Firestore) untuk operasi pembayaran/pesanan
 */
export class PaymentRepository {
    private readonly db = getFirestore();
    private readonly pesananCollection = "pesanan";

    /**
     * Simpan pesanan ke Firestore
     * @param {string} orderId Order ID unik
     * @param {CreateTransactionInput} input Data pesanan
     * @param {string} userId User ID dari auth
     * @param {string} token Midtrans Snap token
     * @param {string} redirectUrl Midtrans redirect URL
     * @return {Promise<void>}
     */
    async savePesanan(
        orderId: string,
        input: CreateTransactionInput,
        userId: string,
        token: string,
        redirectUrl: string
    ): Promise<void> {
        const pesanan: PesananDocument = {
            orderId,
            userId,
            items: input.items.map((item) => ({
                id: item.id,
                name: item.name,
                price: item.price,
                quantity: item.quantity,
                subtotal: item.price * item.quantity,
            })),
            shipping: {
                name: input.shipping.name,
                code: input.shipping.code,
                service: input.shipping.service,
                description: input.shipping.description,
                cost: input.shipping.cost,
                etd: input.shipping.etd,
            },
            customer: {
                displayName: input.customer.displayName,
                email: input.customer.email,
                phoneNumber: input.customer.phoneNumber,
                city: input.customer.city,
            },
            totalPrice: input.totalPrice,
            shippingCost: input.shipping.cost,
            grossAmount: input.totalPrice + input.shipping.cost,
            status: "pending",
            midtransToken: token,
            midtransRedirectUrl: redirectUrl,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp(),
        };

        await this.db
            .collection(this.pesananCollection)
            .doc(orderId)
            .set(pesanan);
    }

    /**
     * Update status pesanan di Firestore
     * @param {string} orderId Order ID
     * @param {string} status Status baru dari Midtrans
     * @param {string} paymentType Tipe pembayaran (e.g. "bank_transfer")
     * @return {Promise<boolean>} true jika dokumen ditemukan dan diupdate
     */
    async updatePesananStatus(
        orderId: string,
        status: string,
        paymentType?: string
    ): Promise<boolean> {
        const docRef = this.db
            .collection(this.pesananCollection)
            .doc(orderId);

        const doc = await docRef.get();
        if (!doc.exists) {
            return false;
        }

        const updateData: Record<string, unknown> = {
            status,
            updatedAt: FieldValue.serverTimestamp(),
        };

        if (paymentType) {
            updateData.paymentType = paymentType;
        }

        await docRef.update(updateData);
        return true;
    }
}
