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
exports.UserService = void 0;
const logger = __importStar(require("firebase-functions/logger"));
/**
 * User Service
 * Logika bisnis untuk operasi user
 */
class UserService {
    /**
       * @param {UserRepository} userRepository Repository untuk user
       */
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    /**
       * Handle user signup - membuat dokumen user di Firestore
       * Dipanggil oleh Auth trigger ketika user baru terdaftar
       * @param {CreateUserInput} input Data user dari Firebase Auth
       * @return {Promise<void>}
       */
    async handleUserSignup(input) {
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
        }
        catch (error) {
            logger.error(`Failed to create user document for ${input.uid}`, error);
            throw error;
        }
    }
}
exports.UserService = UserService;
//# sourceMappingURL=user.service.js.map