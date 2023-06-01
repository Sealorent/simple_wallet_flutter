import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/page/addActivity.dart';
import 'package:wallet/page/wallet.dart';
import 'package:wallet/repositories/database.dart';

import '../models/activity.dart';

class ActivityPage extends StatefulWidget {
  final idWallet;
  const ActivityPage({Key? key, required this.idWallet}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  addActivity() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => AddActivity(idWallet: widget.idWallet)),
    );
  }

  home() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              WalletPage(idUser: localStorage.getInt('id_user'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Aktivitas Keuangan'),
        ),
        body: FutureBuilder(
          future: dbHelper.getAllActivity(widget.idWallet),
          builder:
              (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length < 1) {
                return Center(
                  child: Text('Data Masih Kosong'),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Card(
                        color: Colors.amberAccent,
                        child: ListTile(
                            leading: Icon(
                                snapshot.data![index].type == 1
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: snapshot.data![index].type == 1
                                    ? Colors.red
                                    : Colors.green),
                            title: Text(
                              'Deskripsi : ${snapshot.data![index].description}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Total: ${snapshot.data![index].amount}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                      );
                    });
              }
            } else {
              return CircularProgressIndicator();
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
                onPressed: addActivity,
                heroTag: "btn1",
              ),
              const SizedBox(
                height: 5,
              ),
              FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: home,
              ),
            ]));
  }
}
