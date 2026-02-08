"use strict";
/**
 * Firebase Cloud Functions - A&W Project
 *
 * Entry point yang menghubungkan semua functions
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteProduct = exports.createProduct = exports.onUserCreate = void 0;
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
//# sourceMappingURL=index.js.map