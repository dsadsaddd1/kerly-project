import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kerly/changenotifier.dart';
import 'package:kerly/item_detail_page.dart';

// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

import 'package:provider/provider.dart';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  Result result;

  Orders({
    required this.result,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
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

class OrderInsertPage extends StatefulWidget {
  final int id;

  const OrderInsertPage({Key? key, required this.id}) : super(key: key);

  @override
  State<OrderInsertPage> createState() => _OrderInsertPageState();
}

class _OrderInsertPageState extends State<OrderInsertPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool isLoading = false;

  int _id = 0;
  String _itemName = "";
  String _itemDescribe = "";
  String _itemType = "";
  String _username = "";
  int _ea = 0;

  String _createDate = "";
  String _updateDate = "";
  int _price = 0;
  int _discount = 0;
  String _totalPrice = "";
  int _bid = 0;

  List<Map<String, dynamic>> _orderItems = [];

  int _quantity = 1; // 상품 개수를 저장하는 변수

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
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

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        _id = data['result']['id'];
        _itemName = data['result']['itemName'];
        _itemDescribe = data['result']['itemDescribe'];
        _itemType = data['result']['itemType'];
        _username = data['result']['username'];
        _ea = data['result']['ea'];
        _price = (data['result']['price']);
        _discount = (data['result']['discount']);
        _createDate = data['result']['createDate'];
        _updateDate = data['result']['updateDate'];
        double totalPrice = (_price * (100 - _discount)) / 100;
        _totalPrice = totalPrice.toStringAsFixed(0);
        _bid = _id;

      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> insertNewOrder() async {

    String totalPrice = (int.parse(_totalPrice) * _quantity).toString();

    _orderItems = [
      {
        "itemId" : _id,
        "itemName" : _itemName,
        "itemPrice" : _price,
        "itemStock" : _quantity,
        "itemSellerName" : _username,
        "itemTotalPrice" : totalPrice,
      }
    ];
    print(_username);

    Map<String, dynamic> body = {
      "orderItems": _orderItems,
      "username": Provider.of<MemberModel>(context, listen: false).username,
      "totalPrice": totalPrice
    };

    try {
      String url = 'http://10.0.2.2:9007/neworder2-service/createNewOrder';
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("알림"),
          content: Text("구매가 완료되었습니다."),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                // 이전 페이지로 돌아가기

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }










  Future<void> processOrderInset() async {

    String totalPrice = (int.parse(_totalPrice) * _quantity).toString();

    Map<String, dynamic> body = {
      "username": Provider.of<MemberModel>(context, listen: false).username,
      "productId": _id,
      "ea": _quantity,
      "unitPrice": _totalPrice,
      "totalPrice": totalPrice,
      "productName": _itemName
    };

    try {
      String url = 'http://10.0.2.2:9007/order-service/createOrder';
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      if (response.statusCode != 200) {
        throw Exception();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => ItemDetailPage(id: widget.id, initialTabIndex: 0),
        ),
      );

    } catch (e) {
    } finally {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상품 구매"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25,),
            Text(
              "상품명: $_itemName",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 10),
            Divider(),
            Text(
              "상품설명: $_itemDescribe",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 10),
            Divider(),
            Text(
              "상품종류: $_itemType",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 10),
            Divider(),
            Text(
              "상품가격: $_totalPrice",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 10),
            Divider(),
            Row(
              children: [
                Text(
                  "상품개수:",
                  style: TextStyle(fontSize: 25),
                ),
                IconButton(
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity -= 1)
                      : null,
                  icon: Icon(Icons.remove_circle_outline),
                ),
                Text(
                  _quantity.toString(),
                  style: TextStyle(fontSize: 25),
                ),
                IconButton(
                  onPressed: () => setState(() => _quantity += 1),
                  icon: Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            Text(
              "총가격: ${int.parse(_totalPrice) * _quantity}",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  insertNewOrder();
                  // processOrderInset();
                  // 구매하기 버튼을 눌렀을 때 처리하는 로직 작성
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.pinkAccent), // 원하는 색상으로 변경
                ),
                child: Text("구매하기"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
