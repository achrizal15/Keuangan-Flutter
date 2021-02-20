import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Coba extends StatefulWidget {
  @override
  _CobaState createState() => _CobaState();
}

class _CobaState extends State<Coba> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference users = firestore.collection('users');
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            users.doc(auth.currentUser.uid).collection('pemasukan').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            int pemasukan = 0;

            snapshot.data.docs.forEach((element) {
              pemasukan += element.data()['jumlah'];
            });
            return Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: users
                    .doc(auth.currentUser.uid)
                    .collection('pengeluaran')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    int pengeluaran = 0;
                    snapshot.data.docs.forEach((element) {
                      pengeluaran += element.data()['jumlah'];
                    });
                    return RaisedButton(onPressed: () {
                      if (pemasukan < pengeluaran) {
                        print('saldo Tidak Cukup');
                      } else {
                        users
                            .doc(auth.currentUser.uid)
                            .update({'saldo': pemasukan - pengeluaran});
                      }
                    });
                  } else {
                    return Text('Await');
                  }
                },
              ),
            );
          } else {
            return Text('waitting');
          }
        },
      ),
    );
  }
}
