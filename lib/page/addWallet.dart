import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/models/wallet.dart';
import 'package:wallet/page/wallet.dart';

import '../repositories/database.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({super.key});

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  late DatabaseHelper dbHelper;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  var idUser;

  @override
  void initState() {
    dbHelper = DatabaseHelper();
    super.initState();
  }

  Future<int> addWalletToDatabase(Wallet wallet) async {
    return await dbHelper.addWallet(wallet);
  }

  void addWalletto() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      idUser = localStorage.getInt('id_user');
    });
    Wallet wallet =
        Wallet(idUser: idUser, name: nameController.text, amount: 0);
    print(wallet);
    var res = await addWalletToDatabase(wallet);
    print(res);
    if (res == 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('success')));
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => WalletPage(idUser: idUser)),
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
        title: const Text('Add Wallet'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Nama Wallet",
                label: Text("Nama Wallet"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: addWalletto, child: const Text("add"))
          ],
        ),
      ),
    );
  }
}
