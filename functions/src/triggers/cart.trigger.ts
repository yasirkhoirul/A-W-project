import * as logger from "firebase-functions/logger";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {CartService} from "../services/cart.service.js";
import {CartRepository} from "../repositories/cart.repository.js";
import {CreateCartInput} from "../models/cart.model.js";

// Dependency Injection
const cartRepository = new CartRepository();
const cartService = new CartService(cartRepository);

/**
 * Create Cart
 * Callable function untuk membuat keranjang belanja
 *
 * Input:
 * - items: Array of { productId: string, quantity: number }
 *
 * Output:
 * - user: UserInfo (info user yang hit - WAJIB authenticated)
 * - products: CartItem[] (produk dengan quantity dan subtotal)
 * - totalPrice: number (total harga semua produk)
 * - totalWeight: number (total berat semua produk dalam gram)
 * - totalItems: number (total jumlah item - sum of quantities)
 * - productCount: number (jumlah jenis produk unik)
 *
 * REQUIREMENTS:
 * - User HARUS authenticated
 * - SEMUA product ID HARUS valid (ada di Firestore)
 * - Quantity harus >= 1
 * - Jika ada product tidak ditemukan, akan throw error
 */
export const createCart = onCall(
  {
    memory: "256MiB",
    timeoutSeconds: 30,
    invoker: "public", // Allow public invocation (validasi auth di dalam function)
  },
  async (request) => {
    try {
      // WAJIB authenticated
      if (!request.auth) {
        throw new HttpsError(
          "unauthenticated",
          "User must be authenticated to create cart"
        );
      }

      const input: CreateCartInput = request.data;

      // Validate input structure
      if (!input.items || !Array.isArray(input.items)) {
        throw new HttpsError(
          "invalid-argument",
          "items must be an array of { productId: string, quantity: number }"
        );
      }

      if (input.items.length === 0) {
        throw new HttpsError(
          "invalid-argument",
          "items array cannot be empty"
        );
      }

      // Validate each item
      for (const item of input.items) {
        if (!item.productId || typeof item.productId !== "string" ||
            item.productId.trim() === "") {
          throw new HttpsError(
            "invalid-argument",
            "Each item must have a valid productId (non-empty string)"
          );
        }
        if (!item.quantity || typeof item.quantity !== "number" ||
            item.quantity < 1 || !Number.isInteger(item.quantity)) {
          throw new HttpsError(
            "invalid-argument",
            "Each item must have a valid quantity (integer >= 1)"
          );
        }
      }

      // Build user info from auth token (basic info)
      // Address will be fetched from Firestore in the service
      const userBasicInfo = {
        uid: request.auth.uid,
        email: request.auth.token.email || null,
        displayName: request.auth.token.name || null,
        photoURL: request.auth.token.picture || null,
      };

      // Process cart creation (service will fetch address from Firestore)
      const result = await cartService.createCart(input, userBasicInfo);

      logger.info("Cart created successfully", {
        userId: result.user.uid,
        productCount: result.productCount,
        totalItems: result.totalItems,
        totalPrice: result.totalPrice,
        totalWeight: result.totalWeight,
      });

      return result;
    } catch (error) {
      logger.error("Error creating cart", error);

      if (error instanceof HttpsError) {
        throw error;
      }

      // Handle product not found error
      if (error instanceof Error &&
          error.message.startsWith("Product(s) not found:")) {
        throw new HttpsError(
          "not-found",
          error.message
        );
      }

      throw new HttpsError(
        "internal",
        `Failed to create cart: ${error instanceof Error ? error.message : "Unknown error"}`
      );
    }
  }
);
