"use strict";
/**
 * Firebase Cloud Functions - A&W Project
 *
 * Entry point yang menghubungkan semua functions
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.onPesananStatusChanged = exports.midtransNotification = exports.createTransaction = exports.createCart = exports.deleteProduct = exports.createProduct = exports.onUserCreate = void 0;
const firebase_functions_1 = require("firebase-functions");
const app_1 = require("firebase-admin/app");
// Initialize Firebase Admin SDK
(0, app_1.initializeApp)();
// Set global options untuk semua functions
(0, firebase_functions_1.setGlobalOptions)({ maxInstances: 10 });
// ============================================
// Auth Triggers
// ============================================
var auth_trigger_js_1 = require("./triggers/auth.trigger.js");
Object.defineProperty(exports, "onUserCreate", { enumerable: true, get: function () { return auth_trigger_js_1.onUserCreate; } });
// ============================================
// Product Triggers
// ============================================
var product_trigger_js_1 = require("./triggers/product.trigger.js");
Object.defineProperty(exports, "createProduct", { enumerable: true, get: function () { return product_trigger_js_1.createProduct; } });
Object.defineProperty(exports, "deleteProduct", { enumerable: true, get: function () { return product_trigger_js_1.deleteProduct; } });
// ============================================
// Cart Triggers
// ============================================
var cart_trigger_js_1 = require("./triggers/cart.trigger.js");
Object.defineProperty(exports, "createCart", { enumerable: true, get: function () { return cart_trigger_js_1.createCart; } });
// ============================================
// Payment Triggers
// ============================================
var payment_trigger_js_1 = require("./triggers/payment.trigger.js");
Object.defineProperty(exports, "createTransaction", { enumerable: true, get: function () { return payment_trigger_js_1.createTransaction; } });
Object.defineProperty(exports, "midtransNotification", { enumerable: true, get: function () { return payment_trigger_js_1.midtransNotification; } });
// ============================================
// Notification Triggers
// ============================================
var notification_trigger_js_1 = require("./triggers/notification.trigger.js");
Object.defineProperty(exports, "onPesananStatusChanged", { enumerable: true, get: function () { return notification_trigger_js_1.onPesananStatusChanged; } });
//# sourceMappingURL=index.js.map