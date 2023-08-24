// import 'package:flutter/material.dart';
// import 'package:kerly/changenotifier.dart';
// import 'package:kerly/sql/address_crud.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Logout{
//   static void logout(BuildContext context, Widget widget) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString("token", "");
//     await prefs.setString("username", "");
//     await prefs.setString("name", "");
//     await prefs.setInt('selectedAddressIndex', -1);
//     await prefs.setString('address', "");
//     await prefs.setString('detailInfo', "");
//
//
//     var member = Provider.of<MemberModel>(context, listen: false);
//
//
//
//
//     member.allClear();
//
//     await SqlAddressCrudRepository.deleteAll();
//   }
//
//
// }
import 'package:flutter/material.dart';
import 'package:kerly/changenotifier.dart';
import 'package:kerly/sql/address_crud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout{
  static void logout(BuildContext context, Widget widget) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", "");
    await prefs.setString("username", "");
    await prefs.setString("name", "");
    await prefs.setInt('selectedAddressIndex', -1);
    await prefs.setString('address', "");
    await prefs.setString('detailInfo', "");
    await prefs.setInt('role', 0);
    await prefs.setString('selectedAddress', "");
    await prefs.setString('selectedDetailInfo', "");


    var member = Provider.of<MemberModel>(context, listen: false);




    member.allClear();

    await SqlAddressCrudRepository.deleteAll();
  }


}