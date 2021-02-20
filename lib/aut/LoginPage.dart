
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:keuangan/aut/Authenti.dart';
import 'package:provider/provider.dart';
import 'package:keuangan/aut/Register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _kunci = GlobalKey<FormState>();
  String password, email;
  String loading = 'Login';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
                          'LOGIN',
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
                          margin: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: TextFormField(
                            validator: (value) => (value.length <= 0)
                                ? 'Jangan Dikosongkan'
                                : null,
                            onSaved: (value) => password = value,
                            cursorColor: Colors.orange[400],
                            obscureText: true,
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Register(),
                                  ));
                                },
                                child: Text(
                                  'REGISTER',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )),
                        RaisedButton(
                          color: Colors.orange,
                          splashColor: Colors.amber,
                          child: Text(loading),
                          onPressed: loading == 'Loading'
                              ? null
                              : () async {
                                  final form = _kunci.currentState;
                                  form.save();

                                  if (form.validate()) {
                                    setState(() {
                                      loading = 'Loading';
                                    });
                                    await context
                                        .read<AuthServise>()
                                        .signIn(
                                            email: email.trim(),
                                            password: password.trim())
                                        .then((value) {
                                      _displaySnackBar(
                                          context, value.toString());
                                    }).whenComplete(() => setState(() {
                                              loading = 'Login';
                                            }));
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: StreamBuilder(
                stream: Connectivity().onConnectivityChanged,
                builder: (_, connt) {
                  if (connt.data == ConnectivityResult.wifi ||
                      connt.data == ConnectivityResult.mobile) {
                    return SizedBox();
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height / 1,
                      width: MediaQuery.of(context).size.width / 1,
                      color: Colors.white60,
                      child: Center(
                        child: Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                }),
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
