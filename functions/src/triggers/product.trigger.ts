import * as logger from "firebase-functions/logger";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {ProductService} from "../services/product.service.js";
import {ProductRepository} from "../repositories/product.repository.js";
import {CreateProductInput, ProductCategory} from "../models/product.model.js";

// Dependency Injection
const productRepository = new ProductRepository();
const productService = new ProductService(productRepository);

// Valid categories
const validCategories: ProductCategory[] = [
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
export const createProduct = onCall(
  {
    memory: "512MiB",
    timeoutSeconds: 120,
  },
  async (request) => {
    // Check authentication
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "User must be authenticated to create products"
      );
    }

    const {name, description, price, category, images} = request.data;

    // Validate required fields
    if (!name || typeof name !== "string") {
      throw new HttpsError("invalid-argument", "Product name is required");
    }
    if (!description || typeof description !== "string") {
      throw new HttpsError(
        "invalid-argument",
        "Product description is required"
      );
    }
    if (typeof price !== "number" || price < 0) {
      throw new HttpsError(
        "invalid-argument",
        "Product price must be a positive number"
      );
    }
    if (!category || !validCategories.includes(category)) {
      throw new HttpsError(
        "invalid-argument",
        `Product category must be one of: ${validCategories.join(", ")}`
      );
    }
    if (!images || !Array.isArray(images) || images.length === 0) {
      throw new HttpsError(
        "invalid-argument",
        "At least one product image is required"
      );
    }

    try {
      const input: CreateProductInput = {
        name: name.trim(),
        description: description.trim(),
        price,
        category,
        images,
      };

      const product = await productService.createProduct(
        input,
        request.auth.uid
      );

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
        },
      };
    } catch (error) {
      logger.error("Failed to create product", error);

      if (error instanceof Error) {
        if (error.message.includes("Not authorized")) {
          throw new HttpsError("permission-denied", error.message);
        }
        throw new HttpsError("internal", error.message);
      }

      throw new HttpsError("internal", "Failed to create product");
    }
  }
);

/**
 * Delete Product - Admin Only
 * Callable function untuk menghapus produk beserta gambar-gambarnya
 *
 * Input:
 * - productId: string
 */
export const deleteProduct = onCall(
  {
    memory: "256MiB",
    timeoutSeconds: 60,
  },
  async (request) => {
    // Check authentication
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "User must be authenticated to delete products"
      );
    }

    const {productId} = request.data;

    // Validate required fields
    if (!productId || typeof productId !== "string") {
      throw new HttpsError("invalid-argument", "Product ID is required");
    }

    try {
      await productService.deleteProduct(productId, request.auth.uid);

      logger.info(`Product deleted via callable: ${productId}`);

      return {
        success: true,
        message: `Product ${productId} deleted successfully`,
      };
    } catch (error) {
      logger.error("Failed to delete product", error);

      if (error instanceof Error) {
        if (error.message.includes("Not authorized")) {
          throw new HttpsError("permission-denied", error.message);
        }
        if (error.message.includes("not found")) {
          throw new HttpsError("not-found", error.message);
        }
        throw new HttpsError("internal", error.message);
      }

      throw new HttpsError("internal", "Failed to delete product");
    }
  }
);
