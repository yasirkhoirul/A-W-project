/**
 * Firebase Cloud Functions - A&W Project
 *
 * Entry point yang menghubungkan semua functions
 */

import {setGlobalOptions} from "firebase-functions";
import {initializeApp} from "firebase-admin/app";

// Initialize Firebase Admin SDK
initializeApp();

// Set global options untuk semua functions
setGlobalOptions({maxInstances: 10});

// ============================================
// Auth Triggers
// ============================================
export {onUserCreate} from "./triggers/auth.trigger.js";
