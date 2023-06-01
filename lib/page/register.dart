import 'package:flutter/material.dart';
import 'package:wallet/models/users.dart';
import 'package:wallet/page/login.dart';
import 'package:wallet/repositories/database.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late DatabaseHelper dbHelper;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    dbHelper = DatabaseHelper();
    super.initState();
  }

  Future<int> addUser(Users user) async {
    return await dbHelper.register(user);
  }

  void registerUser() async {
    Users user =
        Users(name: usernameController.text, password: passwordController.text);
    var res = await addUser(user);
    if (res == 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('success')));
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('failed')));
    }
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
            ElevatedButton(
                onPressed: registerUser, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}
