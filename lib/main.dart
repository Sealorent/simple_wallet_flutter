import 'package:flutter/material.dart';
import 'package:wallet/models/wallet.dart';
import 'package:wallet/page/login.dart';
import 'package:wallet/page/register.dart';
import 'package:wallet/page/wallet.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const Login(),
      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => const Login(),
      },
    );
  }
}
