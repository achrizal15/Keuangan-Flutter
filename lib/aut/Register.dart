import 'package:flutter/material.dart';
import 'package:keuangan/aut/Authenti.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _kunci = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String nama, password, email;
  String loading = 'Create';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      key: _scaffoldKey,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
                  margin: EdgeInsets.fromLTRB(20, 250, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Form(
                    key: _kunci,
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('images/auth.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Text(
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: TextFormField(
                            cursorColor: Colors.amber,
                            validator: (value) => (value.length <= 0)
                                ? 'Jangan Dikosongkan'
                                : null,
                            onSaved: (value) => email = value,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: 'Email',
                                prefixText: ': ',
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.orange),
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: Colors.orange[400],
                                ),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.orange[400],
                                ))),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: TextFormField(
                            cursorColor: Colors.amber,
                            validator: (value) => (value.length <= 0)
                                ? 'Jangan Dikosongkan'
                                : null,
                            onSaved: (value) => nama = value,
                            decoration: InputDecoration(
                                hintText: 'Nama',
                                prefixText: ': ',
                                labelText: 'Nama',
                                labelStyle: TextStyle(color: Colors.orange),
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.orange[400],
                                ),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.orange[400],
                                ))),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: TextFormField(
                            validator: (value) => (value.length <= 0)
                                ? 'Jangan Dikosongkan'
                                : null,
                            cursorColor: Colors.orange[400],
                            obscureText: true,
                            onSaved: (value) => password = value,
                            decoration: InputDecoration(
                                prefixText: ': ',
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.orange),
                                hintText: 'Password',
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.orange[400],
                                ),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.orange[400],
                                ))),
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: InkWell(
                                splashColor: Colors.yellow,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )),
                        RaisedButton(
                            color: Colors.orange,
                            splashColor: Colors.amber,
                            child: Text('$loading'),
                            onPressed: loading == 'isLoading'
                                ? null
                                : () async {
                                    final form = _kunci.currentState;
                                    form.save();
                                    if (form.validate()) {
                                      setState(() {
                                        loading = 'isLoading';
                                      });
                                      await context
                                          .read<AuthServise>()
                                          .signUp(
                                              email: email,
                                              password: password,
                                              nama: nama)
                                          .then((value) {
                                        if (value == 'Sukses') {
                                          Navigator.pop(context);
                                        } else {
                                          _displaySnackBar(
                                              context, value.toString());
                                        }
                                      }).whenComplete(() {
                                        setState(() {
                                          loading = 'Create';
                                        });
                                      });
                                    }
                                  })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _displaySnackBar(BuildContext context, String value) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 5),
      content: Text(value),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
