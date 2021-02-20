import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DaftarAnggaranBaru extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference newAnggaran = firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('anggaran');
    return StreamBuilder<QuerySnapshot>(
      stream: newAnggaran.orderBy('date',descending:true).limit(5).snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, i) {
              String txt = snapshot.data.docs[i].data()['detail'].toString();
              int num = i + 1;
              return Text(num.toString() + '. ' + txt,
                  style: TextStyle(color: Colors.grey[600], fontSize: 15));
            },
          );
        } else {
          return Text('Loading Mohon Sabar');
        }
      },
    );
  }
}
