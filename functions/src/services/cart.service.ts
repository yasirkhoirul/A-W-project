import * as logger from "firebase-functions/logger";
import {CartRepository} from "../repositories/cart.repository.js";
import {
  CreateCartInput,
  CreateCartResponse,
  CartItem,
  UserInfo,
} from "../models/cart.model.js";

/**
 * Basic user info dari auth token
 */
export interface UserBasicInfo {
  uid: string;
  email: string | null;
  displayName: string | null;
  photoURL: string | null;
}

/**
 * Cart Service
 * Logika bisnis untuk operasi keranjang belanja
 */
export class CartService {
  /**
   * @param {CartRepository} cartRepository Repository untuk cart
   */
  constructor(private readonly cartRepository: CartRepository) {}

  /**
   * Proses pembuatan keranjang
   * - Validasi items (productId + quantity)
   * - Cek keberadaan produk di Firestore (SEMUA HARUS VALID)
   * - Hitung total harga dan berat berdasarkan quantity
   * - Fetch user address dari Firestore
   *
   * @param {CreateCartInput} input Data input dengan items
   * @param {UserBasicInfo} userBasic Basic user info dari auth token
   * @return {Promise<CreateCartResponse>} Response dengan detail produk dan total
   */
  async createCart(
    input: CreateCartInput,
    userBasic: UserBasicInfo
  ): Promise<CreateCartResponse> {
    logger.info(`Creating cart with ${input.items.length} items`, {
      userId: userBasic.uid,
    });

    // Validasi input
    if (!input.items || input.items.length === 0) {
      throw new Error("Items array cannot be empty");
    }

    // Build quantity map dari items (merge jika ada duplicate productId)
    const quantityMap = new Map<string, number>();
    input.items.forEach((item) => {
      const currentQty = quantityMap.get(item.productId) || 0;
      quantityMap.set(item.productId, currentQty + item.quantity);
    });

    // Get unique product IDs
    const uniqueProductIds = [...quantityMap.keys()];

    logger.info(`Processing ${uniqueProductIds.length} unique product IDs`);

    // Fetch products dan user data secara paralel
    const [productsMap, userData] = await Promise.all([
      this.cartRepository.getProductsByIds(uniqueProductIds),
      this.cartRepository.getUserById(userBasic.uid),
    ]);

    // Build complete user info dengan address dari Firestore
    const user: UserInfo = {
      uid: userBasic.uid,
      email: userBasic.email,
      displayName: userBasic.displayName,
      photoURL: userBasic.photoURL,
      phoneNumber: userData?.phoneNumber || null,
      address: userData?.address || null,
    };

    // Cek apakah ada product yang tidak ditemukan
    const invalidProductIds: string[] = [];
    uniqueProductIds.forEach((productId) => {
      if (!productsMap.has(productId)) {
        invalidProductIds.push(productId);
      }
    });

    // Jika ada product yang tidak valid, throw error
    if (invalidProductIds.length > 0) {
      throw new Error(
        `Product(s) not found: ${invalidProductIds.join(", ")}`
      );
    }

    // Build cart items dengan quantity
    const products: CartItem[] = [];
    let totalPrice = 0;
    let totalWeight = 0;
    let totalItems = 0;

    uniqueProductIds.forEach((productId) => {
      const product = productsMap.get(productId)!;
      const quantity = quantityMap.get(productId)!;

      const subtotalPrice = product.price * quantity;
      const subtotalWeight = product.weight * quantity;

      const cartItem: CartItem = {
        id: product.id,
        name: product.name,
        price: product.price,
        weight: product.weight,
        category: product.category,
        images: product.images,
        quantity,
        subtotalPrice,
        subtotalWeight,
      };

      products.push(cartItem);
      totalPrice += subtotalPrice;
      totalWeight += subtotalWeight;
      totalItems += quantity;
    });

    logger.info(`Cart created successfully`, {
      userId: user.uid,
      productCount: products.length,
      totalItems,
      totalPrice,
      totalWeight,
    });

    return {
      user,
      products,
      totalPrice,
      totalWeight,
      totalItems,
      productCount: products.length,
    };
  }
}
