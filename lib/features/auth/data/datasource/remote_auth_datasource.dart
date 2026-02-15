import 'package:a_and_w/features/auth/data/model/profile_model.dart';
import 'package:a_and_w/features/auth/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide FirebaseException;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:logger/web.dart';

abstract class RemoteAuthDataSource {
  Future<User> signInWithGoogle();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> signUpWithEmailAndPassword(UserEntities dataUser);
  Stream<ProfileModel?> getProfile(String uid);
  Future<void> updateProfile(ProfileModel profile);
  Future<void> signOut();
  Future<void> saveFcmToken(String uid);
  Future<void> removeFcmToken(String uid);
}

class RemoteAuthDatasourceImpl implements RemoteAuthDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final GoogleSignIn googleSignIn;
  final FirebaseMessaging firebaseMessaging;

  const RemoteAuthDatasourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firebaseFirestore,
    required this.firebaseMessaging,
  });

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Login gagal');
      }

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<User> signUpWithEmailAndPassword(UserEntities userData) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );

      if (credential.user == null) {
        throw const AuthException('Registrasi gagal');
      }

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthException('Login Google dibatalkan');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw const AuthException('Login Google gagal');
      }

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    } catch (e) {
      Logger().e(e.toString());
      if (e.toString().contains('network')) {
        throw const NetworkException();
      }
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Stream<ProfileModel?> getProfile(String uid) {
    return firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) {
          final data = event.data();
          Logger().d('Raw data dari Firestore: $data');

          if (data == null) {
            Logger().d('Data null untuk uid: $uid');
            return null;
          }

          final profile = ProfileModel.fromJson(data);
          Logger().d('Profile berhasil diparsing: ${profile.toString()}');
          return profile;
        })
        .handleError((error) {
          Logger().e('Error saat get profile: $error');
          if (error is firebase_core.FirebaseException) {
            throw DatabaseException.fromFirebase(error);
          }
          throw UnknownException(error.toString());
        });
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      final data = profile.toJson();
      data.removeWhere((key, value) => value == null);

      Logger().d('Updating profile for uid: ${profile.uid} with data: $data');
      await firebaseFirestore.collection('users').doc(profile.uid).update(data);
    } on firebase_core.FirebaseException catch (e) {
      Logger().e('FirebaseException saat update profile: ${e.code}');
      throw DatabaseException.fromFirebase(e);
    } catch (e) {
      Logger().e('Unknown error saat update profile: $e');
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<void> saveFcmToken(String uid) async {
    try {
      final token = await firebaseMessaging.getToken();
      if (token == null) {
        Logger().w('FCM token is null, skipping save');
        return;
      }

      Logger().d('Saving FCM token for uid: $uid');
      await firebaseFirestore.collection('users').doc(uid).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
      });
      Logger().d('FCM token saved successfully');
    } catch (e) {
      Logger().w('Failed to save FCM token: $e');
    }
  }

  @override
  Future<void> removeFcmToken(String uid) async {
    try {
      final token = await firebaseMessaging.getToken();

      if (token == null) {
        Logger().w('FCM token is null, skipping remove');
        return;
      }

      Logger().d('Removing FCM token for uid: $uid');
      await firebaseFirestore.collection('users').doc(uid).update({
        'fcmTokens': FieldValue.arrayRemove([token]),
      });

      await firebaseMessaging.deleteToken();
      Logger().d('FCM token removed successfully');
    } catch (e) {
      Logger().e('Error removing FCM token: $e');
    }
  }
}
