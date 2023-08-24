import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kerly/categories_page.dart';
import 'package:kerly/changenotifier.dart';
import 'package:kerly/my_homepage.dart';
import 'package:kerly/notcomplete.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Sample> sampleFromJson(String str) =>
    List<Sample>.from(json.decode(str).map((x) => Sample.fromJson(x)));

String sampleToJson(List<Sample> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sample {
  int id;
  String itemName;
  int price;
  int discount;
  String username;
  int ea;
  String itemDescribe;
  String itemType;
  DateTime createDate;
  DateTime updateDate;

  Sample({
    required this.id,
    required this.itemName,
    required this.price,
    required this.discount,
    required this.username,
    required this.ea,
    required this.itemDescribe,
    required this.itemType,
    required this.createDate,
    required this.updateDate,
  });

  factory Sample.fromJson(Map<String, dynamic> json) => Sample(
    id: json["id"],
    itemName: json["itemName"],
    price: json["price"],
    discount: json["discount"],
    username: json["username"],
    ea: json["ea"],
    itemDescribe: json["itemDescribe"],
    itemType: json["itemType"],
    createDate: DateTime.parse(json["createDate"]),
    updateDate: DateTime.parse(json["updateDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "itemName": itemName,
    "price": price,
    "discount": discount,
    "username": username,
    "ea": ea,
    "itemDescribe": itemDescribe,
    "itemType": itemType,
    "createDate": createDate.toIso8601String(),
    "updateDate": updateDate.toIso8601String(),
  };
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;
  String? username;
  String? name;
  String? address;
  String? detailInfo;
  int? selectedAddressIndex;
  bool? bookmark;
  bool isLoadLoginData = false;
  String? content;
  int? bid;
  int? role;
  String? productName;



  @override
  void initState() {
    loadingPref();

  }

  void loadingPref() async {
    setState(() {
      isLoadLoginData = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString("token") ?? "";
    username = await prefs.getString("username") ?? "";
    name = await prefs.getString("name") ?? "";
    role = (await prefs.getInt("role") ?? "") as int?;
    selectedAddressIndex = await prefs.getInt("selectedAddressIndex");

    setState(() {
      isLoadLoginData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              MemberModel(username: username, name: name, token: token, role: role),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressModel(
              address: address,
              detailInfo: detailInfo,
              selectedAddressIndex: selectedAddressIndex),
        ),
        ChangeNotifierProvider(
            create: (context) => FavoriteModel(bookmark: bookmark)),
        ChangeNotifierProvider(
            create: (context) => ShoppingCartModel()),

        // ChangeNotifierProvider(
        //   create: (context) => ReplyModel(
        //       content: content,
        //       bid: bid,
        //       productName: productName),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoadLoginData ? NotComplete() : MyHomePage(initialTabIndex: 0,),
        routes: {
          '/categories': (context) => CategoriesPage(),
        },
      ),
    );
  }
}