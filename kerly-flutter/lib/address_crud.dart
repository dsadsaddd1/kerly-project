import 'package:kerly/sql/address.dart';
import 'package:kerly/sql/sqldatabase.dart';

class SqlAddressCrudRepository {
  static Future<Address> create(Address ar) async {
    var db = await SqlDataBase.instance.database;

    var id = await db.insert(Address.tableName, ar.toJson());

    return ar.updateAddress(id: id);
  }

  static Future<List<Address>> getList() async {
    var db = await SqlDataBase.instance.database;

    var result = await db.query(Address.tableName,
        columns: ["id", "postCode", "address", "detailInfo"], orderBy: "id DESC");

    return result.map((e) => Address.fromJson(e)).toList();
  }

  static Future<Address?> getAddressById(int id) async {
    var db = await SqlDataBase.instance.database;

    var result = await db.query(Address.tableName,
        columns: ["id", "postCode", "address", "detailInfo"],
        where: "id=?",
        whereArgs: [id]);

    var list = result.map((e) => Address.fromJson(e)).toList();
    if (list.isNotEmpty) {
      return list.first; //list[0];
    } else {
      return null;
    }
  }

  static Future<int> updateById(Address ar) async {
    var db = await SqlDataBase.instance.database;
    return await db.update(Address.tableName, ar.toJson(),
        where: "id=?", whereArgs: [ar.id]);
  }

  static Future<int> deleteById(int id) async {
    var db = await SqlDataBase.instance.database;
    return await db.delete(Address.tableName, where: "id=?", whereArgs: [id]);
  }
}