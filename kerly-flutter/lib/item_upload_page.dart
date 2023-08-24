import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kerly/item_control_page.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'changenotifier.dart';


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


class ItemUploadPage extends StatefulWidget {
  const ItemUploadPage({Key? key}) : super(key: key);

  @override
  State<ItemUploadPage> createState() => _ItemUploadPageState();
}

class _ItemUploadPageState extends State<ItemUploadPage> {
  bool _isLoading = false;
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDescribeController = TextEditingController();
  TextEditingController _eaController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();

  String itemName = "";
  String itemDescribe = "";
  String itemType = "";
  int ea = 0;
  int price = 0;
  int discount = 0;
  int id = 0;

  String selectedItemType = "";



  void processUpload() async {


    setState(() {
      _isLoading = true;
    });

    String url = 'http://10.0.2.2:9007/item-service/item/manager';
    itemName = _itemNameController.text;
    itemDescribe = _itemDescribeController.text;
    ea = int.parse(_eaController.text);
    price = int.parse(_priceController.text);
    discount = int.parse(_discountController.text);


    try {
      Map<String, dynamic> body = {
        "itemName": itemName,
        "itemDescribe": itemDescribe,
        "itemType": selectedItemType,
        "ea": ea,
        "price": price,
        "discount": discount,
        "username" : Provider.of<MemberModel>(context, listen: false).username
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        id = data['result']['id'];
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ItemControlPage()),
      );

    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상품 등록"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30,),
              TextField(
                controller: _itemNameController,
                decoration: InputDecoration(labelText: '상품명'),
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _itemDescribeController,
                decoration: InputDecoration(labelText: '상품설명'),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              DropdownButtonFormField<String>(
                iconSize: 44,
                value: selectedItemType,
                items: [
                  DropdownMenuItem(
                    value: "",
                    child: Text("종류를 선택하세요.",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "과일·채소",
                    child: Text("과일·채소",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "정육·계란",
                    child: Text("정육·계란",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "수산·해산",
                    child: Text("수산·해산",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "샐러드·간편식",
                    child: Text("샐러드·간편식",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "면·양념",
                    child: Text("면·양념",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "생수·음료",
                    child: Text("생수·음료",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "우유·치즈",
                    child: Text("우유·치즈",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "간식·과자",
                    child: Text("간식·과자",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "베이커리·떡",
                    child: Text("베이커리·떡",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedItemType = value!;
                  });
                },
                decoration: InputDecoration(labelText: '상품종류'),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _eaController,
                decoration: InputDecoration(labelText: '상품수량'),
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (int.tryParse(value) != null) {
                    int discountValue = int.parse(value);
                    if (discountValue < 1) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('경고'),
                          content: Text('수량은 0개 이하가 될 수 없습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('확인'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: '상품가격'),
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (int.tryParse(value) != null) {
                    int discountValue = int.parse(value);
                    if (discountValue < 1) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('경고'),
                          content: Text('가격은 0원 이하가 될 수 없습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('확인'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _discountController,
                decoration: InputDecoration(labelText: '할인율'),
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (int.tryParse(value) != null) {
                    int discountValue = int.parse(value);
                    if (discountValue < 0 || discountValue > 100) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('경고'),
                          content: Text('할인율은 0부터 100 사이의 값으로 입력해주세요.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('확인'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    processUpload();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  child: Text("등록")),
              SizedBox(height: 4,),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text("취소")),
            ],
          ),
        ),
      ),
    );
  }
}