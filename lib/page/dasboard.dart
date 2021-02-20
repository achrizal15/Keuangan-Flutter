import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keuangan/aut/Authenti.dart';
import 'package:keuangan/page/components/AnggaranList.dart';
import 'package:keuangan/server/cloud_service.dart';
import 'package:provider/provider.dart';
import 'package:keuangan/page/components/papankartu.dart';
import 'package:keuangan/page/form/Anggaran.dart';
import 'package:keuangan/page/form/Pemasukan.dart';
import 'package:keuangan/page/form/Pengeluaran.dart';

class DasboardPage extends StatefulWidget {
  @override
  _DasboardPageState createState() => _DasboardPageState();
}

class _DasboardPageState extends State<DasboardPage> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Klik Lanjutkan Untuk Keluar'),
          actions: <Widget>[
            TextButton(
              child: Text('Lanjutkan', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await context.read<AuthServise>().signOut();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String nama;

  @override
  void initState() {
    super.initState();
    getName();
  }

  void getName() async {
    dynamic result = await GetUserAdmin().getName();
    if (result == null) {
      nama = 'Nama Tidak Terbaca';
    } else {
      setState(() {
        nama = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference users = firestore.collection('users');
    return Scaffold(
      backgroundColor: Colors.orange[300],
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nama == null ? "Loading" : nama,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: users.doc(auth.currentUser.uid).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    NumberFormat.currency(locale: 'id', symbol: 'Saldo Rp.')
                        .format(snapshot.data.data()['saldo']),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  );
                } else {
                  return Text('Loading');
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                _showMyDialog();
              })
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              margin: EdgeInsets.all(10),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Pemasukan()));
                      },
                      child: StreamBuilder<QuerySnapshot>(
                          stream: users
                              .doc(auth.currentUser.uid)
                              .collection('pemasukan')
                              .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              int rpMasuk = 0;
                              snapshot.data.docs.forEach((element) {
                                rpMasuk += element.data()['jumlah'];
                              });
                              return KartuPapan(
                                src:
                                    'images/pemasukan.webp',
                                caption: 'Uang Masuk',
                                caption2: rpMasuk,
                              );
                            } else {
                              return Text('Loading');
                            }
                          })),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Pengeluaran()));
                      },
                      child: StreamBuilder<QuerySnapshot>(
                          stream: users
                              .doc(auth.currentUser.uid)
                              .collection('pengeluaran')
                              .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              int rp = 0;
                              snapshot.data.docs.forEach((element) {
                                rp += element.data()['jumlah'];
                              });
                              return KartuPapan(
                                src:
                                    'images/pengeluaran.webp',
                                caption2: rp,
                                caption: 'Uang Keluar',
                              );
                            } else {
                              return KartuPapan(
                                src:
                                    'images/pengeluaran.webp',
                                caption2: 0,
                                caption: 'Loading',
                              );
                            }
                          })),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 210, 10, 0),
              padding: EdgeInsets.fromLTRB(2, 10, 2, 0),
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1,
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Anggaran()));
                        },
                        child: StreamBuilder<QuerySnapshot>(
                          stream: users
                              .doc(auth.currentUser.uid)
                              .collection('anggaran')
                              .snapshots(),
                          builder: (_, snapshot) {
                            int totalAnggaran = 0;
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Loading');
                            } else if (snapshot.connectionState ==
                                ConnectionState.none) {
                              return Text('Data IsEmpty');
                            } else {
                              snapshot.data.docs.forEach((element) {
                                totalAnggaran += element.data()['jumlah'];
                              });
                              return KartuPapan(
                                src:
                                    'images/anggaran.webp',
                                caption2: totalAnggaran,
                                caption: 'Anggaran',
                              );
                            }
                          },
                        )),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 200,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Anggaran Terbaru',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                            height: 150,
                            width: 160,
                            padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: DaftarAnggaranBaru())
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
