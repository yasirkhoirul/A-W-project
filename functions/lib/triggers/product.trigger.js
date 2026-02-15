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
exports.deleteProduct = exports.createProduct = void 0;
const logger = __importStar(require("firebase-functions/logger"));
const https_1 = require("firebase-functions/v2/https");
const product_service_js_1 = require("../services/product.service.js");
const product_repository_js_1 = require("../repositories/product.repository.js");
// Dependency Injection
const productRepository = new product_repository_js_1.ProductRepository();
const productService = new product_service_js_1.ProductService(productRepository);
// Valid categories
const validCategories = [
    "makanan",
    "pakaian",
    "sepatu",
    "elektronik",
];
/**
 * Create Product - Admin Only
 * Callable function untuk membuat produk baru dengan gambar
 *
 * Input:
 * - name: string
 * - description: string
 * - price: number
 * - category: "makanan" | "pakaian" | "sepatu" | "elektronik"
 * - images: string[] (base64 encoded images)
 */
exports.createProduct = (0, https_1.onCall)({
    memory: "512MiB",
    timeoutSeconds: 120,
}, async (request) => {
    // Check authentication
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "User must be authenticated to create products");
    }
    const { name, description, price, category, images, weight } = request.data;
    // Validate required fields
    if (!name || typeof name !== "string") {
        throw new https_1.HttpsError("invalid-argument", "Product name is required");
    }
    if (!description || typeof description !== "string") {
        throw new https_1.HttpsError("invalid-argument", "Product description is required");
    }
    if (typeof price !== "number" || price < 0) {
        throw new https_1.HttpsError("invalid-argument", "Product price must be a positive number");
    }
    if (typeof weight !== "number" || weight <= 0) {
        throw new https_1.HttpsError("invalid-argument", "Product weight must be a positive number (in grams)");
    }
    if (!category || !validCategories.includes(category)) {
        throw new https_1.HttpsError("invalid-argument", `Product category must be one of: ${validCategories.join(", ")}`);
    }
    if (!images || !Array.isArray(images) || images.length === 0) {
        throw new https_1.HttpsError("invalid-argument", "At least one product image is required");
    }
    try {
        const input = {
            name: name.trim(),
            description: description.trim(),
            price,
            category,
            images,
            weight,
        };
        const product = await productService.createProduct(input, request.auth.uid);
        logger.info(`Product created via callable: ${product.id}`);
        return {
            success: true,
            product: {
                id: product.id,
                name: product.name,
                description: product.description,
                price: product.price,
                category: product.category,
                images: product.images,
                weight: product.weight,
            },
        };
    }
    catch (error) {
        logger.error("Failed to create product", error);
        if (error instanceof Error) {
            if (error.message.includes("Not authorized")) {
                throw new https_1.HttpsError("permission-denied", error.message);
            }
            throw new https_1.HttpsError("internal", error.message);
        }
        throw new https_1.HttpsError("internal", "Failed to create product");
    }
});
/**
 * Delete Product - Admin Only
 * Callable function untuk menghapus produk beserta gambar-gambarnya
 *
 * Input:
 * - productId: string
 */
exports.deleteProduct = (0, https_1.onCall)({
    memory: "256MiB",
    timeoutSeconds: 60,
}, async (request) => {
    // Check authentication
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "User must be authenticated to delete products");
    }
    const { productId } = request.data;
    // Validate required fields
    if (!productId || typeof productId !== "string") {
        throw new https_1.HttpsError("invalid-argument", "Product ID is required");
    }
    try {
        await productService.deleteProduct(productId, request.auth.uid);
        logger.info(`Product deleted via callable: ${productId}`);
        return {
            success: true,
            message: `Product ${productId} deleted successfully`,
        };
    }
    catch (error) {
        logger.error("Failed to delete product", error);
        if (error instanceof Error) {
            if (error.message.includes("Not authorized")) {
                throw new https_1.HttpsError("permission-denied", error.message);
            }
            if (error.message.includes("not found")) {
                throw new https_1.HttpsError("not-found", error.message);
            }
            throw new https_1.HttpsError("internal", error.message);
        }
        throw new https_1.HttpsError("internal", "Failed to delete product");
    }
});
//# sourceMappingURL=product.trigger.js.map