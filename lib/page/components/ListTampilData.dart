import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTampilData extends StatelessWidget {
  final String detail;
  final int subtili;
  final DateTime date;
  final Function deletData;
  final Function ceklis;

  const ListTampilData({
    Key key,
    this.detail,
    this.subtili,
    this.date,
    this.deletData,
    this.ceklis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference saldo = firestore.collection('users');
    return Container(
        height: 58,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        decoration: BoxDecoration(
            color: Colors.orange[200],
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    Text(NumberFormat.currency(
                            locale: 'id', symbol: 'Rp.', decimalDigits: 0)
                        .format(subtili))
                  ],
                )),
            Text(DateFormat.yMMMMd().format(date).toString()),
            ceklis == null
                ? Text('')
                : StreamBuilder<DocumentSnapshot>(
                    stream: saldo.doc(auth.currentUser.uid).snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        int totSaldo = snapshot.data.data()['saldo'];

                        return IconButton(
                            icon: Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              if (totSaldo == null ||totSaldo<subtili) {
                                final snackBar = SnackBar(
                                  duration: Duration(seconds: 5),
                                  content:
                                      Text('Mohon Maaf Saldo Masih Kurang'),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                              } else {
                                ceklis.call();
                                saldo
                                    .doc(auth.currentUser.uid)
                                    .update({'saldo': totSaldo - subtili});
                              }
                            });
                      } else {
                        return IconButton(
                            icon: Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            onPressed: null);
                      }
                    }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: deletData)
          ],
        ));
  }
}
