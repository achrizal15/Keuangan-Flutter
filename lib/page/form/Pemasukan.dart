import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:keuangan/page/components/ListTampilData.dart';
import 'package:keuangan/page/components/dropdownWidget.dart';

// keterangan,tanggal,uangmasuk,bulan
class Pemasukan extends StatefulWidget {
  @override
  _PemasukanState createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  final _key = GlobalKey<FormState>();
  String detail, jumlah, dateValidation;
  String dropdownValue = 'All';
  DateTime inputDate;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference pemasukan = firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('pemasukan');
    CollectionReference saldo = firestore.collection('users');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.orange[300],
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              Navigator.pop(context);
            }),
        shadowColor: Colors.transparent,
        title: Text(
          'Pemasukan',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 2.7,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Form(
                key: _key,
                child: ListView(
                  children: [
                    Text('Tambah Data',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      validator: (value) =>
                          (value.length <= 0) ? 'Jangan Dikosongkan' : null,
                      onSaved: (value) => detail = value,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Detail',
                        labelStyle:
                            TextStyle(fontSize: 18, color: Colors.black),
                        enabledBorder: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) =>
                          (value.length <= 0) ? 'Jangan Dikosongkan' : null,
                      textCapitalization: TextCapitalization.words,
                      onSaved: (value) => jumlah = value,
                      cursorColor: Colors.black,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jumlah',
                        labelStyle:
                            TextStyle(fontSize: 18, color: Colors.black),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Masukkan Tanggal :',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        FlatButton(
                          child: dateValidation == 'Tanggal Kosong'
                              ? Text(
                                  'Tanggal Kosong',
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text((dateValidation != 'Tanggal Kosong' &&
                                      dateValidation != null)
                                  ? 'Saat Ini ' + dateValidation
                                  : 'Masukkan Date & Time'),
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2020),
                                maxTime: DateTime.now(),
                                locale: LocaleType.id, onConfirm: (date) {
                              setState(() {
                                dateValidation =
                                    DateFormat.yMMMd().format(date);
                                inputDate = date;
                              });
                            });
                          },
                        )
                      ],
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: saldo.doc(auth.currentUser.uid).snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return RaisedButton(onPressed: null);
                        } else {
                          int totSaldo = snapshot.data.data()['saldo'];
                          return RaisedButton(
                            color: Colors.orange,
                            child: Text('Masukkan Data'),
                            onPressed: () {
                              final form = _key.currentState;
                              form.save();

                              if (dateValidation == null) {
                                setState(() {
                                  dateValidation = 'Tanggal Kosong';
                                });
                              }
                              if (form.validate() &&
                                  dateValidation != null &&
                                  dateValidation != 'Tanggal Kosong') {
                                pemasukan.add({
                                  'detail': detail,
                                  'jumlah': int.parse(jumlah),
                                  'date': Timestamp.fromDate(inputDate),
                                  'bulan': DateFormat.MMMM()
                                      .format(inputDate)
                                      .toString()
                                });

                                saldo.doc(auth.currentUser.uid).update(
                                    {'saldo': totSaldo + int.parse(jumlah)});
                                form.reset();
                              }
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 390,
              child: Column(
                children: [
                  DropdownWidget(
                    dropdownValue: dropdownValue,
                    fungsi: (String value) {
                      setState(() {
                        dropdownValue = value;
                      });
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1,
                    height: MediaQuery.of(context).size.height / 2.5,
                    color: Colors.white70,
                    padding: EdgeInsets.all(5),
                    child: ListView(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: dropdownValue == 'All'
                              ? pemasukan.snapshots()
                              : pemasukan
                                  .where('bulan', isEqualTo: dropdownValue)
                                  .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.docs.isEmpty) {
                                return Text(
                                  'Data Tidak di Temukan!',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18),
                                );
                              } else {
                                return Column(
                                  children: snapshot.data.docs
                                      .map((e) => ListTampilData(
                                            detail: e.data()['detail'],
                                            subtili: e.data()['jumlah'],
                                            date: e.data()['date'].toDate(),
                                            deletData: () async {
                                              await pemasukan
                                                  .doc(e.id)
                                                  .delete();
                                            },
                                          ))
                                      .toList(),
                                );
                              }
                            } else {
                              return Text('Loading');
                            }
                          },
                        )
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
// int total;

// @override
// void initState() {
//   super.initState();
//   totalPemasukan();
// }

// totalPemasukan() async {
//   dynamic result = await GetUserAdmin().getTotalPemasukan();
//   if (result == null) {
//     setState(() {
//       total = 0;
//     });
//   } else {
//     setState(() {
//       total = result;
//     });
//   }
// }
// Text(
//   total == 0
//       ? 'Rp.0'
//       : total == null
//           ? 'Loading'
//           : 'Rp.' + total.toString(),
//   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
// ),
