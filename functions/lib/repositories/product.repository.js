"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductRepository = void 0;
const firestore_1 = require("firebase-admin/firestore");
const storage_1 = require("firebase-admin/storage");
/**
 * Product Repository
 * Urusan database (Firestore) dan Storage untuk products collection
 */
class ProductRepository {
    constructor() {
        this.db = (0, firestore_1.getFirestore)();
        this.storage = (0, storage_1.getStorage)();
        this.collection = "products";
        this.bucketName = this.storage.bucket().name;
    }
    /**
         * Upload gambar ke Firebase Storage
         * @param {string} productId ID produk
         * @param {string[]} base64Images Array gambar dalam format base64
         * @return {Promise<string[]>} Array URL gambar yang sudah diupload
         */
    async uploadImages(productId, base64Images) {
        const bucket = this.storage.bucket();
        const uploadedUrls = [];
        for (let i = 0; i < base64Images.length; i++) {
            const base64Data = base64Images[i];
            // Parse base64 data (format: data:image/jpeg;base64,/9j/4AAQ...)
            const matches = base64Data.match(/^data:(.+);base64,(.+)$/);
            if (!matches) {
                throw new Error(`Invalid base64 format for image ${i}`);
            }
            const contentType = matches[1];
            const imageBuffer = Buffer.from(matches[2], "base64");
            const extension = contentType.split("/")[1] || "jpg";
            const fileName = `products/${productId}/${Date.now()}_${i}.${extension}`;
            const file = bucket.file(fileName);
            await file.save(imageBuffer, {
                metadata: { contentType },
                public: true,
            });
            // Get public URL
            const publicUrl = `https://storage.googleapis.com/${this.bucketName}/${fileName}`;
            uploadedUrls.push(publicUrl);
        }
        return uploadedUrls;
    }
    /**
         * Hapus gambar dari Firebase Storage
         * @param {string[]} imageUrls Array URL gambar yang akan dihapus
         */
    async deleteImages(imageUrls) {
        const bucket = this.storage.bucket();
        for (const url of imageUrls) {
            try {
                // Extract file path from URL
                const filePath = url.replace(`https://storage.googleapis.com/${this.bucketName}/`, "");
                await bucket.file(filePath).delete();
            }
            catch (error) {
                // Log but don't throw - image might already be deleted
                console.warn(`Failed to delete image: ${url}`, error);
            }
        }
    }
    /**
         * Membuat dokumen produk baru di Firestore
         * @param {CreateProductInput} input Data produk
         * @param {string} createdBy UID admin yang membuat
         * @param {string[]} imageUrls URL gambar yang sudah diupload
         * @return {Promise<ProductModel>} ProductModel yang dibuat
         */
    async createProduct(input, createdBy, imageUrls) {
        const docRef = this.db.collection(this.collection).doc();
        const newProduct = {
            id: docRef.id,
            name: input.name,
            description: input.description,
            price: input.price,
            category: input.category,
            images: imageUrls,
            createdAt: firestore_1.FieldValue.serverTimestamp(),
            updatedAt: firestore_1.FieldValue.serverTimestamp(),
            createdBy: createdBy,
        };
        await docRef.set(newProduct);
        return newProduct;
    }
    /**
         * Ambil data produk berdasarkan ID
         * @param {string} productId ID produk
         * @return {Promise<ProductModel | null>} ProductModel atau null jika
         * tidak ada
         */
    async getProduct(productId) {
        const doc = await this.db.collection(this.collection).doc(productId).get();
        if (!doc.exists) {
            return null;
        }
        return doc.data();
    }
    /**
         * Hapus produk dari Firestore
         * @param {string} productId ID produk
         */
    async deleteProduct(productId) {
        await this.db.collection(this.collection).doc(productId).delete();
    }
}
exports.ProductRepository = ProductRepository;
//# sourceMappingURL=product.repository.js.map