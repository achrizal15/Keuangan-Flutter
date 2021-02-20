import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keuangan/aut/Authenti.dart';
import 'package:keuangan/aut/LoginPage.dart';
import 'package:keuangan/page/dasboard.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthServise>(
              create: (_) => AuthServise(FirebaseAuth.instance)),
          StreamProvider(
            create: (context) => context.read<AuthServise>().authStateChanges,
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: WrapperAuth(),
          title: 'Siklus Keuangan',
        ));
  }
}

class WrapperAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return DasboardPage();
    } else {
      return LoginPage();
    }
  }
}
