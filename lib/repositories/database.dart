import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallet/models/users.dart';

import '../models/activity.dart';
import '../models/wallet.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  late Database db;

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'users_demo.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL,
              password TEXT NOT NULL
            )
          """,
        );
        await database.execute(
          """
            CREATE TABLE wallet (
              id_wallet INTEGER PRIMARY KEY AUTOINCREMENT, 
              id_user INTEGER NOT NULL, 
              name TEXT NOT NULL,
              amount INTEGER NOT NULL
            )
          """,
        );
        await database.execute(
          """
            CREATE TABLE activity (
              id_activity INTEGER PRIMARY KEY AUTOINCREMENT,
              id_wallet INTEGER NOT NULL,
              type INTEGER NOT NULL, 
              description TEXT NOT NULL,
              amount INTEGER NOT NULL
            )
          """,
        );
      },
      version: 1,
    );
  }

  Future<int> register(Users user) async {
    var res = await db.rawQuery(
        "SELECT * FROM users WHERE name = '${user.name}' and password = '${user.password}'");
    if (res.isNotEmpty) {
      return 0;
    } else {
      await db.insert('users', user.toMap());
      return 1;
    }
  }

  Future<Users?> login(Users user) async {
    var res = await db.rawQuery(
        "SELECT * FROM users WHERE name = '${user.name}' and password = '${user.password}'");
    if (res.isNotEmpty) {
      return Users.fromMap(res.first);
    } else {
      return Users.fromMap(res.first);
    }
  }

  Future<Users?> getUser(int id) async {
    var res = await db.rawQuery('SELECT * FROM users WHERE id=? ', [id]);
    if (res.isNotEmpty) {
      return Users.fromMap(res.first);
    } else {
      return Users.fromMap(res.first);
    }
  }

  Future<int> addWallet(Wallet wallet) async {
    var res =
        await db.rawQuery("SELECT * FROM wallet WHERE name = '${wallet.name}'");
    if (res.isNotEmpty) {
      print('2');
      return 0;
    } else {
      await db.insert('wallet', wallet.toMap());
      print('1');
      return 1;
    }
  }

  Future<List<Wallet>> getWallet(int id) async {
    var res = await db.rawQuery('SELECT * FROM wallet WHERE id_user=? ', [id]);
    List<Wallet> list =
        res.isNotEmpty ? res.map((m) => Wallet.fromMap(m)).toList() : [];
    return list;
  }

  Future<List<Activity>> getAllActivity(int id) async {
    var res =
        await db.rawQuery('SELECT * FROM activity WHERE id_wallet=? ', [id]);
    List<Activity> list =
        res.isNotEmpty ? res.map((m) => Activity.fromMap(m)).toList() : [];
    return list;
  }

  Future<int> saveActivity(Activity activity) async {
    // get Amount
    var amount;
    var totalAmount;
    amount = await db.rawQuery(
        'SELECT amount FROM wallet WHERE id_wallet=?', [activity.idWallet]);
    amount = amount.isNotEmpty ? amount[0]['amount'] : null;
    if (amount == null) {
      return 0;
    }
    // check type tarik or simpan
    if (activity.type == 1) {
      if (amount < activity.amount) {
        return 0;
      } else {
        totalAmount = amount - activity.amount;
      }
    }

    if (activity.type == 2) {
      totalAmount = amount + activity.amount;
    }
    print(totalAmount);
    await db.rawUpdate('''
                      UPDATE wallet 
                      SET amount = ? 
                      WHERE id_wallet = ?
                      ''', [totalAmount, activity.idWallet]);
    var res = await db.insert('activity', activity.toMap());
    if (res == null) {
      return 0;
    } else {
      return 1;
    }
  }
}
