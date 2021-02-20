import 'package:firebase_auth/firebase_auth.dart';

import 'package:keuangan/server/cloud_service.dart';

class AuthServise {
  final FirebaseAuth _firebaseAuth; //* Constructor panggil

  AuthServise(this._firebaseAuth);
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    //*Method SignIn
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return "Sukses";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future signUp({String email, String password, String nama}) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await UserAdmin(uid: result.user.uid).usersAdminData(nama);
      return 'Sukses';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
