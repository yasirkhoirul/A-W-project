import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions/v1";
import {UserService} from "../services/user.service.js";
import {UserRepository} from "../repositories/user.repository.js";

// Dependency Injection
const userRepository = new UserRepository();
const userService = new UserService(userRepository);

/**
 * Auth Trigger: onUserCreate (Gen1)
 * Menggunakan v1 API - diperlukan untuk auth triggers
 *
 * Catatan: Untuk deploy, pastikan Node.js <= 20
 */
export const onUserCreate = functions
  .runWith({memory: "256MB", timeoutSeconds: 60})
  .auth.user()
  .onCreate(async (user) => {
    logger.info(`New user signed up: ${user.uid}`, {
      email: user.email,
      displayName: user.displayName,
      providerData: user.providerData,
    });

    await userService.handleUserSignup({
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    });
  });
