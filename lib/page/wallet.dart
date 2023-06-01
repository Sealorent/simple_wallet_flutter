import 'package:flutter/material.dart';
import 'package:wallet/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/page/activity.dart';
import 'package:wallet/page/addWallet.dart';
import 'package:wallet/repositories/database.dart';

import '../models/wallet.dart';

class WalletPage extends StatefulWidget {
  final idUser;
  const WalletPage({Key? key, required this.idUser}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Users? user;
  var idUserShared;
  var nama;
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    initUser();
  }

  goToAddWallet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddWallet()),
    );
  }

  initUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      idUserShared = localStorage.getInt('id_user');
      nama = localStorage.getString('nama');
    });
    print(widget.idUser);
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    logoutSuccess();
  }

  logoutSuccess() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('success')));
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet $nama'),
        automaticallyImplyLeading: false,
      ),
      // body: const Center(
      //     child: Text(
      //   "Data tidak ada...",
      //   style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30.0),
      // ))
      body: FutureBuilder(
        future: dbHelper.getWallet(widget.idUser),
        builder: (BuildContext context, AsyncSnapshot<List<Wallet>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length < 1) {
              return Center(child: Text('Data Masih Kosong'));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActivityPage(
                                      idWallet: snapshot.data![index].idWallet,
                                    )));
                      },
                      child: Card(
                        color: Colors.amberAccent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                                leading: Icon(Icons.wallet),
                                title: Text(
                                  snapshot.data![index].name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Saldo : ' +
                                      snapshot.data![index].amount.toString(),
                                  style: const TextStyle(),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('DELETE'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('EDIT'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          } else {
            return const Center(
              child: Text(
                "Data tidak ada...",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30.0),
              ),
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: goToAddWallet,
            heroTag: "btn1",
          ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: Colors.red,
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: logout,
          ),
        ],
      ),
    );
  }
}
