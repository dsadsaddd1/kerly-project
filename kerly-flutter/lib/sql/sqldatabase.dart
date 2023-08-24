import 'package:kerly/sql/address.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDataBase {
  Database? _database;

  static final SqlDataBase instance = SqlDataBase._instance();

  factory SqlDataBase() {
    return instance;
  }

  SqlDataBase._instance() {
    _initDataBase();
  }

  Future<Database> get database async {
    if (_database != null) _database;

    await _initDataBase();
    return _database!;
  }

  Future<void> _initDataBase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "address.db");
    _database = await openDatabase(path, version: 1, onCreate: _dataBaseCreate);
  }

  void _dataBaseCreate(Database db, int version) async {
    await db.execute("""
    create table ${Address.tableName} (
      id integer primary key autoincrement,
      postCode text not null,
      address text not null,
      detailInfo text not null
    )
    """);
  }
}