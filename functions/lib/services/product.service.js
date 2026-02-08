"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductService = void 0;
const logger = __importStar(require("firebase-functions/logger"));
const firestore_1 = require("firebase-admin/firestore");
/**
 * Product Service
 * Logika bisnis untuk operasi produk
 */
class ProductService {
    /**
       * @param {ProductRepository} productRepository Repository untuk produk
       */
    constructor(productRepository) {
        this.productRepository = productRepository;
        this.db = (0, firestore_1.getFirestore)();
    }
    /**
       * Verifikasi bahwa user adalah admin
       * @param {string} uid User ID
       * @throws {Error} Jika user bukan admin
       */
    async verifyAdmin(uid) {
        const userDoc = await this.db.collection("users").doc(uid).get();
        if (!userDoc.exists) {
            throw new Error("User not found");
        }
        const userData = userDoc.data();
        if ((userData === null || userData === void 0 ? void 0 : userData.role) !== "admin") {
            throw new Error("Not authorized. Admin only.");
        }
    }
    /**
       * Membuat produk baru - hanya admin
       * @param {CreateProductInput} input Data produk
       * @param {string} adminUid UID user yang request (harus admin)
       * @return {Promise<ProductModel>} Produk yang dibuat
       */
    async createProduct(input, adminUid) {
        // Verify admin
        await this.verifyAdmin(adminUid);
        logger.info(`Admin ${adminUid} creating product: ${input.name}`);
        // Validate input
        if (!input.name || input.name.trim() === "") {
            throw new Error("Product name is required");
        }
        if (input.price < 0) {
            throw new Error("Product price cannot be negative");
        }
        if (!input.images || input.images.length === 0) {
            throw new Error("At least one product image is required");
        }
        // Upload images to Storage
        const tempProductId = Date.now().toString();
        const imageUrls = await this.productRepository.uploadImages(tempProductId, input.images);
        try {
            // Create product in Firestore
            const product = await this.productRepository.createProduct(input, adminUid, imageUrls);
            logger.info(`Product created successfully: ${product.id}`, {
                productId: product.id,
                name: product.name,
                category: product.category,
                imagesCount: product.images.length,
            });
            return product;
        }
        catch (error) {
            // Rollback: delete uploaded images if product creation fails
            await this.productRepository.deleteImages(imageUrls);
            throw error;
        }
    }
    /**
       * Menghapus produk - hanya admin
       * @param {string} productId ID produk
       * @param {string} adminUid UID user yang request (harus admin)
       */
    async deleteProduct(productId, adminUid) {
        // Verify admin
        await this.verifyAdmin(adminUid);
        logger.info(`Admin ${adminUid} deleting product: ${productId}`);
        // Get product to get image URLs
        const product = await this.productRepository.getProduct(productId);
        if (!product) {
            throw new Error("Product not found");
        }
        // Delete images from Storage
        await this.productRepository.deleteImages(product.images);
        // Delete product from Firestore
        await this.productRepository.deleteProduct(productId);
        logger.info(`Product deleted successfully: ${productId}`);
    }
}
exports.ProductService = ProductService;
//# sourceMappingURL=product.service.js.map