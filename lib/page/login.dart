import 'package:flutter/material.dart';
import 'package:wallet/models/wallet.dart';
import 'package:wallet/page/register.dart';
import 'package:wallet/page/wallet.dart';
import 'package:wallet/repositories/database.dart';
import 'package:wallet/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // inisiasi db
  late DatabaseHelper dbHelper;
  // inisiasi users
  Users? user;
  // text controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    dbHelper.initDB().whenComplete(() async {
      setState(() {});
    });
  }

  Future<Users?> login(Users user) async {
    return await dbHelper.login(user);
  }

  loginError() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('failed')));
  }

  loginSuccess(int id) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('success')));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WalletPage(
                  idUser: id,
                )));
  }

  void userLogin() async {
    // inisiasi shared preferences
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // get the user
    Users user =
        Users(name: usernameController.text, password: passwordController.text);
    // function login
    var res = await login(user);
    if (res == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('failed')));
    } else {
      localStorage.setInt('id_user', res.id);
      localStorage.setString('nama', res.name);
      loginSuccess(res.id);
    }
  }

  void toRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Register()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Login Wallet"),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: "username",
                label: Text("Username"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "password",
                label: Text("password"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: userLogin, child: const Text("login")),
            ElevatedButton(
                onPressed: toRegister, child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}
