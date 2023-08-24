import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String tableName = 'address';

  Future<Database> _getDatabase() async {
    final String path = await getDatabasesPath();
    final String databasePath = join(path, 'my_database.db');
    return await openDatabase(databasePath, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            postCode TEXT,
            address TEXT,
            detailInfo TEXT
          )
        ''');
        });
  }
  Future<void> insertData(
      String postCode, String address, String detailInfo) async {
    final Database db = await _getDatabase();
    await db.insert(tableName, {
      'postCode': postCode,
      'address': address,
      'detailInfo': detailInfo,
    });
  }
  Future<List<Map<String, dynamic>>> getAllData() async {
    final Database db = await _getDatabase();
    return await db.query(tableName);
  }
}