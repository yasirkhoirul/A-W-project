"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserRepository = void 0;
const firestore_1 = require("firebase-admin/firestore");
/**
 * User Repository
 * Urusan database (Firestore) untuk user collection
 */
class UserRepository {
    constructor() {
        this.db = (0, firestore_1.getFirestore)();
        this.collection = "users";
    }
    /**
       * Membuat dokumen user baru di Firestore
       * @param {CreateUserInput} input Data user dari Auth trigger
       * @return {Promise<UserModel>} UserModel yang dibuat
       */
    async createUser(input) {
        const newUser = {
            uid: input.uid,
            email: input.email || "",
            displayName: input.displayName || "User Baru",
            photoURL: input.photoURL || "",
            // 🔒 PENTING: Hardcode role. Jangan ambil dari input manapun.
            role: "user",
            phoneNumber: input.phoneNumber || null,
            address: null,
            createdAt: firestore_1.FieldValue.serverTimestamp(),
            updatedAt: firestore_1.FieldValue.serverTimestamp(),
        };
        await this.db.collection(this.collection).doc(input.uid).set(newUser);
        return newUser;
    }
    /**
       * Cek apakah user sudah ada di Firestore
       * @param {string} uid User ID
       * @return {Promise<boolean>} true jika user sudah ada
       */
    async userExists(uid) {
        const doc = await this.db.collection(this.collection).doc(uid).get();
        return doc.exists;
    }
}
exports.UserRepository = UserRepository;
//# sourceMappingURL=user.repository.js.map