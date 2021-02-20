import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:keuangan/page/components/ListTampilData.dart';
import 'package:keuangan/page/components/dropdownWidget.dart';

class Pengeluaran extends StatefulWidget {
  @override
  _PengeluaranState createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<FormState>();
  String detail, jumlah, dateValidation;
  String dropdownValue = 'All';
  DateTime inputDate;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference pengeluaran = firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('pengeluaran');
    CollectionReference saldo = firestore.collection('users');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.orange[300],
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              Navigator.pop(context);
            }),
        shadowColor: Colors.transparent,
        title: Text(
          'Pengeluaran',
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
                                minTime: DateTime(2021),
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
                          if (snapshot.hasData) {
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
                                  if (totSaldo == null ||
                                      totSaldo < int.parse(jumlah)) {
                                    _displaySnackBar(context);
                                  } else {
                                    pengeluaran.add({
                                      'detail': detail,
                                      'jumlah': int.parse(jumlah),
                                      'date': Timestamp.fromDate(inputDate),
                                      'bulan': DateFormat.yMMMM()
                                          .format(inputDate)
                                          .toString()
                                    });
                                    int a = totSaldo - int.parse(jumlah);
                                    saldo
                                        .doc(auth.currentUser.uid)
                                        .update({'saldo': a});
                                    form.reset();
                                  }
                                }
                              },
                            );
                          } else {
                            return Text('Wait');
                          }
                        })
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
                              ? pengeluaran.snapshots()
                              : pengeluaran
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
                                      .map(
                                        (e) => ListTampilData(
                                          detail: e.data()['detail'],
                                          subtili: e.data()['jumlah'],
                                          date: e.data()['date'].toDate(),
                                          deletData: () async {
                                            await pengeluaran
                                                .doc(e.id)
                                                .delete();
                                          },
                                        ),
                                      )
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

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 5),
      content: Text('Mohon Maaf Saldo Masih Kurang'),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
