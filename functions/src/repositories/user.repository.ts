import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { UserModel, CreateUserInput } from "../models/user.model.js";

/**
 * User Repository
 * Urusan database (Firestore) untuk user collection
 */
export class UserRepository {
  private readonly db = getFirestore();
  private readonly collection = "users";

  /**
     * Membuat dokumen user baru di Firestore
     * @param {CreateUserInput} input Data user dari Auth trigger
     * @return {Promise<UserModel>} UserModel yang dibuat
     */
  async createUser(input: CreateUserInput): Promise<UserModel> {
    const newUser: UserModel = {
      uid: input.uid,
      email: input.email || "",
      displayName: input.displayName || "User Baru",
      photoURL: input.photoURL || "",

      // 🔒 PENTING: Hardcode role. Jangan ambil dari input manapun.
      role: "user",

      phoneNumber: input.phoneNumber || null,
      address: null,
      fcmTokens: [],
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    };

    await this.db.collection(this.collection).doc(input.uid).set(newUser);

    return newUser;
  }

  /**
     * Cek apakah user sudah ada di Firestore
     * @param {string} uid User ID
     * @return {Promise<boolean>} true jika user sudah ada
     */
  async userExists(uid: string): Promise<boolean> {
    const doc = await this.db.collection(this.collection).doc(uid).get();
    return doc.exists;
  }

  /**
     * Ambil FCM tokens dari user document
     * @param {string} uid User ID
     * @return {Promise<string[]>} Array of FCM tokens
     */
  async getFcmTokens(uid: string): Promise<string[]> {
    const doc = await this.db.collection(this.collection).doc(uid).get();
    if (!doc.exists) return [];
    const data = doc.data();
    return (data?.fcmTokens as string[]) || [];
  }
}
