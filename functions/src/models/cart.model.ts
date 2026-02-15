/**
 * Cart Model Interface
 * Definisi tipe data untuk keranjang belanja
 */

/**
 * Item input untuk keranjang
 */
export interface CartInputItem {
    productId: string;
    quantity: number;
}

/**
 * Input untuk membuat keranjang
 * Berisi list item dengan productId dan quantity
 */
export interface CreateCartInput {
    items: CartInputItem[];
}

/**
 * Item di keranjang dengan detail produk dan quantity
 */
export interface CartItem {
    id: string;
    name: string;
    price: number;
    weight: number; // Berat dalam gram
    category: string;
    images: string[];
    quantity: number; // Jumlah item
    subtotalPrice: number; // price * quantity
    subtotalWeight: number; // weight * quantity
}

/**
 * Data alamat (provinsi/kota/distrik)
 */
export interface DataAddress {
    id: number;
    nama: string;
}

/**
 * Address untuk user
 */
export interface UserAddress {
    provinsi: DataAddress;
    kota: DataAddress;
    district: DataAddress;
}

/**
 * User info tanpa role (untuk response)
 */
export interface UserInfo {
    uid: string;
    email: string | null;
    displayName: string | null;
    photoURL: string | null;
    phoneNumber: string | null; // Nomor telepon user
    address: UserAddress | null; // Alamat user
}

/**
 * Response untuk create cart
 * Berisi detail produk dan total harga/berat
 * User WAJIB authenticated, semua produk HARUS valid
 */
export interface CreateCartResponse {
    user: UserInfo; // Info user (wajib, tidak boleh null)
    products: CartItem[]; // Produk dengan quantity
    totalPrice: number; // Total harga semua produk
    totalWeight: number; // Total berat semua produk (gram)
    totalItems: number; // Total jumlah item (sum of quantities)
    productCount: number; // Jumlah jenis produk unik
}
