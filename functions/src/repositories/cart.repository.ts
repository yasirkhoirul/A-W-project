import {getFirestore} from "firebase-admin/firestore";
import {ProductModel} from "../models/product.model.js";
import {UserAddress} from "../models/user.model.js";

/**
 * User data yang diperlukan untuk cart
 */
export interface UserCartData {
  phoneNumber: string | null;
  address: UserAddress | null;
}

/**
 * Cart Repository
 * Urusan database (Firestore) untuk operasi keranjang
 */
export class CartRepository {
  private readonly db = getFirestore();
  private readonly productsCollection = "products";
  private readonly usersCollection = "users";

  /**
   * Ambil multiple products berdasarkan array of IDs
   * @param {string[]} productIds Array ID produk
   * @return {Promise<Map<string, ProductModel>>} Map of productId -> ProductModel
   */
  async getProductsByIds(
    productIds: string[]
  ): Promise<Map<string, ProductModel>> {
    const productsMap = new Map<string, ProductModel>();

    // Firestore 'in' query dibatasi 10 items per query
    // Jadi kita split menjadi chunks of 10
    const chunks: string[][] = [];
    for (let i = 0; i < productIds.length; i += 10) {
      chunks.push(productIds.slice(i, i + 10));
    }

    // Query setiap chunk
    for (const chunk of chunks) {
      const querySnapshot = await this.db
        .collection(this.productsCollection)
        .where("id", "in", chunk)
        .get();

      querySnapshot.forEach((doc) => {
        const product = doc.data() as ProductModel;
        productsMap.set(product.id, product);
      });
    }

    return productsMap;
  }

  /**
   * Alternatif: Ambil products satu per satu (lebih banyak read tapi lebih fleksibel)
   * @param {string[]} productIds Array ID produk
   * @return {Promise<Map<string, ProductModel>>} Map of productId -> ProductModel
   */
  async getProductsByIdsIndividually(
    productIds: string[]
  ): Promise<Map<string, ProductModel>> {
    const productsMap = new Map<string, ProductModel>();

    // Fetch semua products secara paralel
    const promises = productIds.map((id) =>
      this.db.collection(this.productsCollection).doc(id).get()
    );

    const docs = await Promise.all(promises);

    docs.forEach((doc, index) => {
      if (doc.exists) {
        const product = doc.data() as ProductModel;
        productsMap.set(productIds[index], product);
      }
    });

    return productsMap;
  }

  /**
   * Ambil data user dari Firestore (phoneNumber dan address)
   * @param {string} uid User ID
   * @return {Promise<UserCartData | null>} User data atau null jika tidak ditemukan
   */
  async getUserById(uid: string): Promise<UserCartData | null> {
    const doc = await this.db.collection(this.usersCollection).doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    const data = doc.data();
    return {
      phoneNumber: data?.phoneNumber || null,
      address: data?.address || null,
    };
  }
}
