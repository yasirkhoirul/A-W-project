import {FieldValue} from "firebase-admin/firestore";

/**
 * User Model Interface
 * Definisi tipe data untuk user di Firestore
 */
export interface UserModel {
  uid: string;
  email: string;
  displayName: string;
  photoURL: string;
  role: "admin" | "user";
  phoneNumber: string | null;
  address: string | null;
  createdAt: FieldValue;
  updatedAt: FieldValue;
}

/**
 * Input untuk membuat user baru dari Auth trigger
 */
export interface CreateUserInput {
  uid: string;
  email: string | undefined;
  displayName: string | undefined;
  photoURL: string | undefined;
  phoneNumber: string | undefined;
}
