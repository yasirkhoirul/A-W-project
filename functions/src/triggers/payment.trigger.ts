import * as logger from "firebase-functions/logger";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onRequest } from "firebase-functions/v2/https";
import { PaymentService } from "../services/payment.service.js";
import { PaymentRepository } from "../repositories/payment.repository.js";
import {
    CreateTransactionInput,
    MidtransNotificationPayload,
} from "../models/payment.model.js";

// Dependency Injection
const paymentRepository = new PaymentRepository();
const paymentService = new PaymentService(paymentRepository);

/**
 * Create Transaction
 * Callable function untuk membuat transaksi Midtrans Snap
 * + menyimpan pesanan ke Firestore
 *
 * Input:
 * - items: Array of { id, name, price, quantity }
 * - shipping: { name, code, service, description, cost, etd }
 * - customer: { uid, displayName, email, phoneNumber, city }
 * - totalPrice: number (total harga barang saja, tanpa ongkir)
 *
 * Output:
 * - token: string (Midtrans Snap token)
 * - redirectUrl: string (URL payment page)
 * - orderId: string (unique order ID)
 *
 * REQUIREMENTS:
 * - User HARUS authenticated
 * - Items tidak boleh kosong
 * - Shipping cost harus > 0
 * - Customer data harus lengkap
 */
export const createTransaction = onCall(
    {
        memory: "256MiB",
        timeoutSeconds: 30,
        invoker: "public",
    },
    async (request) => {
        try {
            // WAJIB authenticated
            if (!request.auth) {
                throw new HttpsError(
                    "unauthenticated",
                    "User must be authenticated to create transaction"
                );
            }

            const input: CreateTransactionInput = request.data;

            // Validate items
            if (!input.items || !Array.isArray(input.items) ||
                input.items.length === 0) {
                throw new HttpsError(
                    "invalid-argument",
                    "items must be a non-empty array"
                );
            }

            // Validate each item
            for (const item of input.items) {
                if (!item.id || !item.name || !item.price || !item.quantity) {
                    throw new HttpsError(
                        "invalid-argument",
                        "Each item must have id, name, price, and quantity"
                    );
                }
                if (item.price <= 0 || item.quantity <= 0) {
                    throw new HttpsError(
                        "invalid-argument",
                        "Item price and quantity must be greater than 0"
                    );
                }
            }

            // Validate shipping
            if (!input.shipping || !input.shipping.cost ||
                input.shipping.cost <= 0) {
                throw new HttpsError(
                    "invalid-argument",
                    "Shipping info with valid cost is required"
                );
            }

            // Validate customer
            if (!input.customer || !input.customer.displayName ||
                !input.customer.email || !input.customer.phoneNumber) {
                throw new HttpsError(
                    "invalid-argument",
                    "Customer details (displayName, email, phoneNumber) are required"
                );
            }

            // Validate totalPrice
            if (!input.totalPrice || input.totalPrice <= 0) {
                throw new HttpsError(
                    "invalid-argument",
                    "totalPrice must be greater than 0"
                );
            }

            // Override customer uid dengan auth uid (security)
            input.customer.uid = request.auth.uid;

            // Create transaction via Midtrans + save to Firestore
            const result = await paymentService.createTransaction(
                input,
                request.auth.uid
            );

            logger.info("Transaction created successfully", {
                userId: request.auth.uid,
                orderId: result.orderId,
            });

            return result;
        } catch (error) {
            logger.error("Error creating transaction", error);

            if (error instanceof HttpsError) {
                throw error;
            }

            throw new HttpsError(
                "internal",
                `Failed to create transaction: ${error instanceof Error ? error.message : "Unknown error"
                }`
            );
        }
    }
);

/**
 * Midtrans Notification Webhook
 * HTTP endpoint yang dipanggil Midtrans saat status pembayaran berubah
 *
 * PENTING: Endpoint ini HARUS public (tanpa auth) agar Midtrans bisa POST
 * Keamanan dijamin via signature verification di Midtrans SDK
 *
 * Flow:
 * 1. Midtrans POST notification ke endpoint ini
 * 2. Verifikasi signature menggunakan Midtrans CoreApi
 * 3. Update status pesanan di Firestore
 * 4. Return 200 OK ke Midtrans
 */
export const midtransNotification = onRequest(
    {
        memory: "256MiB",
        timeoutSeconds: 15,
    },
    async (req, res) => {
        // Hanya terima POST
        if (req.method !== "POST") {
            res.status(405).json({ error: "Method not allowed" });
            return;
        }

        try {
            const notificationJson =
                req.body as MidtransNotificationPayload;

            // Validasi input dasar
            if (!notificationJson.order_id ||
                !notificationJson.transaction_status) {
                logger.warn("Invalid notification payload", notificationJson);
                res.status(400).json({ error: "Invalid notification payload" });
                return;
            }

            logger.info("Received Midtrans notification", {
                orderId: notificationJson.order_id,
                status: notificationJson.transaction_status,
            });

            // Handle notification (verify + update Firestore)
            const result = await paymentService.handleNotification(
                notificationJson
            );

            logger.info("Notification handled successfully", result);

            // Midtrans expects 200 OK
            res.status(200).json({
                success: true,
                orderId: result.orderId,
                status: result.status,
            });
        } catch (error) {
            logger.error("Error handling Midtrans notification", error);
            res.status(500).json({
                error: `Failed to handle notification: ${error instanceof Error ? error.message : "Unknown error"
                    }`,
            });
        }
    }
);
