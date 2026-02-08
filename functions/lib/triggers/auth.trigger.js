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
exports.onUserCreate = void 0;
const logger = __importStar(require("firebase-functions/logger"));
const functions = __importStar(require("firebase-functions/v1"));
const user_service_js_1 = require("../services/user.service.js");
const user_repository_js_1 = require("../repositories/user.repository.js");
// Dependency Injection
const userRepository = new user_repository_js_1.UserRepository();
const userService = new user_service_js_1.UserService(userRepository);
/**
 * Auth Trigger: onUserCreate (Gen1)
 * Menggunakan v1 API - diperlukan untuk auth triggers
 *
 * Catatan: Untuk deploy, pastikan Node.js <= 20
 */
exports.onUserCreate = functions
    .runWith({ memory: "256MB", timeoutSeconds: 60 })
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
//# sourceMappingURL=auth.trigger.js.map