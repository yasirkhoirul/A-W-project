import * as logger from "firebase-functions/logger";
import {getFirestore} from "firebase-admin/firestore";
import {ProductRepository} from "../repositories/product.repository.js";
import {CreateProductInput, ProductModel} from "../models/product.model.js";

/**
 * Product Service
 * Logika bisnis untuk operasi produk
 */
export class ProductService {
  private readonly db = getFirestore();

  /**
     * @param {ProductRepository} productRepository Repository untuk produk
     */
  constructor(private readonly productRepository: ProductRepository) { }

  /**
     * Verifikasi bahwa user adalah admin
     * @param {string} uid User ID
     * @throws {Error} Jika user bukan admin
     */
  private async verifyAdmin(uid: string): Promise<void> {
    const userDoc = await this.db.collection("users").doc(uid).get();

    if (!userDoc.exists) {
      throw new Error("User not found");
    }

    const userData = userDoc.data();
    if (userData?.role !== "admin") {
      throw new Error("Not authorized. Admin only.");
    }
  }

  /**
     * Membuat produk baru - hanya admin
     * @param {CreateProductInput} input Data produk
     * @param {string} adminUid UID user yang request (harus admin)
     * @return {Promise<ProductModel>} Produk yang dibuat
     */
  async createProduct(
    input: CreateProductInput,
    adminUid: string
  ): Promise<ProductModel> {
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
    const imageUrls = await this.productRepository.uploadImages(
      tempProductId,
      input.images
    );

    try {
      // Create product in Firestore
      const product = await this.productRepository.createProduct(
        input,
        adminUid,
        imageUrls
      );

      logger.info(`Product created successfully: ${product.id}`, {
        productId: product.id,
        name: product.name,
        category: product.category,
        imagesCount: product.images.length,
      });

      return product;
    } catch (error) {
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
  async deleteProduct(productId: string, adminUid: string): Promise<void> {
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
