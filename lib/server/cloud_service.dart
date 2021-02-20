import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAdmin {
  final String uid;
  UserAdmin({this.uid});
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  Future usersAdminData(String nama) async {
    return await users.doc(uid).set({
      'nama': nama,
      'saldo': 0,
    });
  }
}

class GetUserAdmin {
  static GetUserAdmin getUserAdmin = GetUserAdmin();
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference user = firestore.collection('users');
  Future<String> getName() async {
    String nama;
    await user
        .doc(auth.currentUser.uid)
        .get()
        .then((value) => nama = value.data()['nama']);
    return nama;
  }
}
