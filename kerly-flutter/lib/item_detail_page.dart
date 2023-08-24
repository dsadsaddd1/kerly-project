import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kerly/board_insert_page.dart';
import 'package:kerly/bottombar.dart';
import 'package:kerly/image_upload_page.dart';
import 'package:kerly/item_update_page.dart';
import 'package:kerly/item_board_page.dart';
import 'package:kerly/login_page.dart';
import 'package:kerly/shopping_cart_page.dart';
import 'package:kerly/user_board_list_page.dart';
import 'package:kerly/user_reply_list_page.dart';
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

class ItemDetailPage extends StatefulWidget {
  final int id;
  final String? uploadedImageUrl;
  final int initialTabIndex;

  const ItemDetailPage(
      {Key? key,
      required this.id,
      this.uploadedImageUrl,
      required this.initialTabIndex})
      : super(key: key);

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTabIndex ?? 0);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController!.index;
      });
    });
    loadData();
    loadImageData();
  }

  bool isLoading = false;
  bool _isDeleting = false;

  Uint8List? _imageBytes;

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
      isLoading = false;
    }
  }

  Future<void> loadImageData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(Uri.parse(
          'http://10.0.2.2:9007/file-service/fileDownload/${widget.id}'));
      if (response.statusCode == 200) {
        setState(() {
          _imageBytes = response.bodyBytes;
          isLoading = false;
        });
      } else {
        // Handle error case
      }
    } catch (e) {
      // Handle error case
    }
  }

  @override
  Widget build(BuildContext context) {
    var member = Provider.of<MemberModel>(context);
    bool isLoggedIn = member.token != "";
    int _selectedIndex = _tabController.index;
    return Scaffold(
      appBar: AppBar(
        title: Text('$_itemName'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          if (_selectedIndex == 2)
            IconButton(
              onPressed: isLoggedIn
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BoardInsertPage(
                                tabController: _tabController, id: _id)),
                      );
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
              icon: Icon(Icons.add_circle_outline),
            ),
          IconButton(
            onPressed: isLoggedIn
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoppingCartPage()),
                    );
                  }
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          tabs: const [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.chat),
            ),
            Tab(
              icon: Icon(Icons.question_answer),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          tabContainer1(),
          tabContainer2(),
          tabContainer(context),
        ],
      ),
      bottomNavigationBar: BottomBar(id: widget.id),
    );
  }

  void processDelete(id) async {
    setState(() {
      _isDeleting = true;
    });

    String url = "http://10.0.2.2:9007/item-service/item/admin";
    Map<String, String> body = {
      "id": id.toString(),
    };

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      Map<String, dynamic> responseData = jsonDecode(response.body);

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ItemBoardPage(_itemType)));
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  Widget tabContainer(BuildContext context) {
    return UserBoardListPage(id: _id);
  }

  Widget tabContainer1() {
    final bool isOwner =
        _username == Provider.of<MemberModel>(context, listen: false).username;

    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      _imageBytes != null
                          ? Image.memory(
                              _imageBytes!,
                              width: 300,
                              height: 300,
                            )
                          : Image.asset(
                              'assets/test1.gif',
                              width: 300,
                              height: 300,
                            ),
                      if (isOwner) // 소유자인 경우에만 표시
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.pinkAccent),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(horizontal: 30)),
                          ),
                          onPressed: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageUploadPage(
                                    id: _id,
                                    username: _username,
                                    itemType: _itemType,
                                    itemName: _itemName),
                              ),
                            );
                          },
                          child: Text("이미지 업로드"),
                        ),
                      SizedBox(height: 10),
                      Text("$_itemName", style: TextStyle(fontSize: 35)),
                      Text("$_itemDescribe", style: TextStyle(fontSize: 20)),
                      Text("상품 종류: $_itemType", style: TextStyle(fontSize: 20)),
                      Text("판매자: $_username", style: TextStyle(fontSize: 20)),
                      Text("정가: $_price", style: TextStyle(fontSize: 20)),
                      Text("할인률: $_discount%", style: TextStyle(fontSize: 23)),
                      Text("최종가: $_totalPrice", style: TextStyle(fontSize: 25)),
                      Text("수량: $_ea", style: TextStyle(fontSize: 15)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "$_createDate".substring(0, 10),
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "$_updateDate".substring(0, 10),
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      if (isOwner) // 소유자인 경우에만 표시
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ItemUpdatePage(id: _id)));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.pinkAccent),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(horizontal: 30)),
                          ),
                          child: Text("수정"),
                        ),
                      if (isOwner) // 소유자인 경우에만 표시
                        ElevatedButton(
                          onPressed: () {
                            processDelete(_id);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.pinkAccent),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(horizontal: 30)),
                          ),
                          child: Text("삭제"),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget tabContainer2() {
    if (!isLoading) {
      return UserReplyListPage(_id);
    } else {
      return CircularProgressIndicator();
    }
  }
}
