import {FieldValue} from "firebase-admin/firestore";

/**
 * Kategori produk yang tersedia
 */
export type ProductCategory = "makanan" | "pakaian" | "sepatu" | "elektronik";

/**
 * Product Model Interface
 * Definisi tipe data untuk produk di Firestore
 */
export interface ProductModel {
    id: string;
    name: string;
    description: string;
    price: number;
    category: ProductCategory;
    images: string[]; // Array URL gambar dari Storage
    weight: number; // Berat dalam gram
    createdAt: FieldValue;
    updatedAt: FieldValue;
    createdBy: string; // UID admin yang membuat
}

/**
 * Input untuk membuat produk baru
 */
export interface CreateProductInput {
    name: string;
    description: string;
    price: number;
    category: ProductCategory;
    images: string[]; // Array base64 images
    weight: number; // Berat dalam gram
}
