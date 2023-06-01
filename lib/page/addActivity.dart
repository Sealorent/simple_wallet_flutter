import 'package:flutter/material.dart';
import 'package:wallet/models/activity.dart';
import 'package:wallet/page/activity.dart';

import '../repositories/database.dart';

class AddActivity extends StatefulWidget {
  final int idWallet;
  const AddActivity({Key? key, required this.idWallet}) : super(key: key);

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  late DatabaseHelper dbHelper;
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  late Type selectedType;
  List<Type> type = <Type>[const Type(1, 'Tarik'), const Type(2, 'Simpan')];

  @override
  void initState() {
    super.initState();
    selectedType = type[0];
    dbHelper = DatabaseHelper();
  }

  Future<int> futureSave(Activity wallet) async {
    return await dbHelper.saveActivity(wallet);
  }

  save() async {
    Activity activity = Activity(
        idWallet: widget.idWallet,
        description: descriptionController.text,
        type: selectedType.id,
        amount: int.parse(amountController.text));
    var res = await futureSave(activity);
    if (res == 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('success')));
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ActivityPage(
                  idWallet: widget.idWallet,
                )),
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
        title: const Text('Tambah Aktivitas Keuangan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            DropdownButtonFormField<Type>(
              isExpanded: true,
              value: selectedType,
              onChanged: (Type? val) {
                setState(() {
                  selectedType = val as Type;
                  // print(selectedUser.id);
                });
              },
              items: type.map((Type user) {
                return DropdownMenuItem<Type>(
                  value: user,
                  child: Text(
                    user.name,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "deskripsi",
                label: Text("deskripsi"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "jumlah",
                label: Text("jumlah"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: save, child: const Text("simpan"))
          ],
        ),
      ),
    );
  }
}

class Type {
  const Type(this.id, this.name);

  final String name;
  final int id;
}
