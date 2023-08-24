import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kerly/item_control_page.dart';
import 'dart:convert';

// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'package:kerly/item_detail_page.dart';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Result result;

  Item({
    required this.result,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
  };
}

class Result {
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

  Result({
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

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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

class ItemUpdatePage extends StatefulWidget {
  const ItemUpdatePage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ItemUpdatePage> createState() => _ItemUpdatePageState();
}

class _ItemUpdatePageState extends State<ItemUpdatePage> {
  bool _isLoading = false;
  late Item _item;

  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDescribeController = TextEditingController();
  TextEditingController _itemTypeController = TextEditingController();
  TextEditingController _eaController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String url = 'http://10.0.2.2:9007/item-service/id/${widget.id}';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      setState(() {
        _item = Item.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

        _itemNameController.text = _item.result.itemName;
        _itemDescribeController.text = _item.result.itemDescribe;
        _itemTypeController.text = _item.result.itemType; // 수정
        _eaController.text = _item.result.ea.toString();
        _priceController.text = _item.result.price.toString();
        _discountController.text = _item.result.discount.toString();
      });
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상품 수정"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30,),
              TextField(
                controller: _itemNameController,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _itemDescribeController,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _itemTypeController,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _eaController,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _priceController,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _discountController,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    processUpdate();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.pinkAccent), // 원하는 색상으로 변경
                  ),
                  child: Text("수정하기")),
              SizedBox(height: 4,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemDetailPage(id: widget.id, initialTabIndex: 0)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey), // 원하는 색상으로 변경
                ),
                child: Text("취소"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void processUpdate() async {
    String itemName = _itemNameController.text;
    String itemDescribe = _itemDescribeController.text;
    String itemType = _itemTypeController.text;
    int ea = int.parse(_eaController.text);
    int price = int.parse(_priceController.text);
    int discount = int.parse(_discountController.text);

    setState(() {
      _isLoading = true;
    });

    String url = 'http://10.0.2.2:9007/item-service/item/admin/update';

    try {
      Map<String, dynamic> body = {
        "id": widget.id,
        "itemName": itemName,
        "itemDescribe": itemDescribe,
        "itemType": itemType,
        "ea": ea,
        "price": price,
        "discount": discount
      };

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception();
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ItemControlPage()));
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
