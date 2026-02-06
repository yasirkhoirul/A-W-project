import 'package:a_and_w/features/auth/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:logger/web.dart';

abstract class RemoteAuthDataSource {
  Future<User> signInWithGoogle();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> signUpWithEmailAndPassword(UserEntities dataUser);
  Future<void> signOut();
}

class RemoteAuthDatasourceImpl implements RemoteAuthDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  const RemoteAuthDatasourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });


  @override
  Future<User> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
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
  Future<User> signUpWithEmailAndPassword(
    UserEntities userData
  ) async {
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

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      
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
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}