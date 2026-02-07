import * as logger from "firebase-functions/logger";
import {UserRepository} from "../repositories/user.repository.js";
import {CreateUserInput} from "../models/user.model.js";

/**
 * User Service
 * Logika bisnis untuk operasi user
 */
export class UserService {
  /**
     * @param {UserRepository} userRepository Repository untuk user
     */
  constructor(private readonly userRepository: UserRepository) { }

  /**
     * Handle user signup - membuat dokumen user di Firestore
     * Dipanggil oleh Auth trigger ketika user baru terdaftar
     * @param {CreateUserInput} input Data user dari Firebase Auth
     * @return {Promise<void>}
     */
  async handleUserSignup(input: CreateUserInput): Promise<void> {
    try {
      // Cek apakah user sudah ada (untuk mencegah duplikasi)
      const exists = await this.userRepository.userExists(input.uid);

      if (exists) {
        logger.info(`User ${input.uid} already exists in Firestore, skipping`);
        return;
      }

      // Buat user baru dengan role "user" (hardcoded di repository)
      const user = await this.userRepository.createUser(input);

      logger.info(`Created new user document for ${user.uid}`, {
        email: user.email,
        displayName: user.displayName,
        role: user.role,
      });
    } catch (error) {
      logger.error(`Failed to create user document for ${input.uid}`, error);
      throw error;
    }
  }
}
