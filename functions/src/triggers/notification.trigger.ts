import * as logger from "firebase-functions/logger";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { UserRepository } from "../repositories/user.repository.js";

// Dependency Injection
const userRepository = new UserRepository();

/**
 * Firestore Trigger: onPesananStatusChanged
 * Dipanggil setiap kali dokumen di collection "pesanan" diupdate
 *
 * Jika field "status" berubah → kirim FCM notification ke semua device user
 */
export const onPesananStatusChanged = onDocumentUpdated(
    {
        document: "pesanan/{orderId}",
        memory: "256MiB",
        timeoutSeconds: 30,
    },
    async (event) => {
        const beforeData = event.data?.before.data();
        const afterData = event.data?.after.data();

        if (!beforeData || !afterData) {
            logger.warn("Missing before/after data in pesanan update");
            return;
        }

        const beforeStatus = beforeData.status as string;
        const afterStatus = afterData.status as string;

        // Hanya proses jika status berubah
        if (beforeStatus === afterStatus) {
            return;
        }

        const orderId = event.params.orderId;
        const userId = afterData.userId as string;

        logger.info("Pesanan status changed", {
            orderId,
            userId,
            beforeStatus,
            afterStatus,
        });

        // Ambil FCM tokens user
        const fcmTokens = await userRepository.getFcmTokens(userId);

        if (fcmTokens.length === 0) {
            logger.warn("No FCM tokens found for user", { userId });
            return;
        }

        // Buat pesan notifikasi
        const statusLabel = getStatusLabel(afterStatus);
        const message = {
            notification: {
                title: "Update Pesanan",
                body: `Status pesanan ${orderId} berubah menjadi ${statusLabel}`,
            },
            data: {
                orderId,
                status: afterStatus,
                type: "order_status_changed",
            },
            tokens: fcmTokens,
        };

        try {
            const response = await getMessaging().sendEachForMulticast(message);

            logger.info("FCM notification sent", {
                orderId,
                successCount: response.successCount,
                failureCount: response.failureCount,
            });

            // Hapus token yang gagal (expired/invalid)
            if (response.failureCount > 0) {
                const tokensToRemove: string[] = [];
                response.responses.forEach((resp, idx) => {
                    if (!resp.success) {
                        const errorCode = resp.error?.code;
                        if (
                            errorCode ===
                            "messaging/invalid-registration-token" ||
                            errorCode ===
                            "messaging/registration-token-not-registered"
                        ) {
                            tokensToRemove.push(fcmTokens[idx]);
                        }
                    }
                });

                if (tokensToRemove.length > 0) {
                    logger.info("Removing invalid FCM tokens", {
                        userId,
                        count: tokensToRemove.length,
                    });
                    // Hapus token invalid dari Firestore
                    const { getFirestore, FieldValue } = await import("firebase-admin/firestore");
                    await getFirestore()
                        .collection("users")
                        .doc(userId)
                        .update({
                            fcmTokens: FieldValue.arrayRemove(tokensToRemove),
                        });
                    logger.info("Invalid FCM tokens removed from Firestore");
                }
            }
        } catch (error) {
            logger.error("Error sending FCM notification", error);
        }
    }
);

/**
 * Map status code ke label yang user-friendly
 */
function getStatusLabel(status: string): string {
    const labels: Record<string, string> = {
        pending: "Menunggu Pembayaran",
        settlement: "Pembayaran Berhasil ✅",
        capture: "Pembayaran Berhasil ✅",
        deny: "Pembayaran Ditolak ❌",
        cancel: "Dibatalkan",
        expire: "Kadaluarsa",
        failure: "Gagal",
    };
    return labels[status] || status;
}
