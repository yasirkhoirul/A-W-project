import 'package:firebase_auth/firebase_auth.dart';

abstract class LocalAuthDatasource {
  User? getCurrentUser();
  Stream<bool> checkSignin();
}

class LocalAuthDatasourceImpl implements LocalAuthDatasource {

  final FirebaseAuth firebaseAuth;
  const LocalAuthDatasourceImpl(this.firebaseAuth);
  @override
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  @override
  Stream<bool> checkSignin(){
    return firebaseAuth.authStateChanges().map((user) => user != null);
  }
}