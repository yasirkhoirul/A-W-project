/**
 * Payment Model Interface
 * Definisi tipe data untuk Midtrans payment
 */

/**
 * Item dalam pesanan (dari cart)
 */
export interface PaymentItem {
    id: string;
    name: string;
    price: number;
    quantity: number;
}

/**
 * Info pengiriman (dari RajaOngkir / DataCekEntity)
 */
export interface ShippingInfo {
    name: string; // Nama kurir (e.g. "JNE")
    code: string; // Kode kurir (e.g. "jne")
    service: string; // Jenis layanan (e.g. "REG")
    description: string; // Deskripsi layanan
    cost: number; // Biaya ongkir
    etd: string; // Estimasi pengiriman
}

/**
 * Info customer untuk Midtrans
 */
export interface CustomerInfo {
    uid: string;
    displayName: string;
    email: string;
    phoneNumber: string;
    city: string; // Kota tujuan
}

/**
 * Input untuk membuat transaksi Midtrans
 * Dikirim dari Flutter saat OnSubmitPesanan
 */
export interface CreateTransactionInput {
    items: PaymentItem[];
    shipping: ShippingInfo;
    customer: CustomerInfo;
    totalPrice: number; // Total harga barang saja (tanpa ongkir)
}

/**
 * Response dari Midtrans Snap createTransaction
 */
export interface CreateTransactionResponse {
    token: string; // Snap token untuk membuka payment page
    redirectUrl: string; // URL redirect Midtrans
    orderId: string; // Order ID unik
}

/**
 * Payload notifikasi dari Midtrans webhook
 */
export interface MidtransNotificationPayload {
    transaction_status: string;
    order_id: string;
    gross_amount: string;
    payment_type: string;
    fraud_status: string;
    status_code: string;
    signature_key: string;
    transaction_id: string;
    transaction_time: string;
    settlement_time?: string;
}
