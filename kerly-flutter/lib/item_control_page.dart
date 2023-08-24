import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kerly/changenotifier.dart';
import 'package:kerly/image_upload_page.dart';
import 'package:kerly/item_detail_page.dart';
import 'package:kerly/item_update_page.dart';
import 'package:kerly/item_upload_page.dart';
import 'package:kerly/my_homepage.dart';
import 'package:provider/provider.dart';

class ItemControlPage extends StatefulWidget {
  const ItemControlPage({Key? key}) : super(key: key);

  @override
  State<ItemControlPage> createState() => _ItemControlPageState();
}

class _ItemControlPageState extends State<ItemControlPage> {
  int pageNum = 0;
  List<dynamic> _list = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Map<int, Uint8List> _imageMap = {};

  Future<void> loadData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    String url =
        'http://10.0.2.2:9007/item-service/username/username?username=${Provider.of<MemberModel>(context, listen: false).username}&pageNum=${pageNum}';

    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        _list.addAll(result);
      });
      pageNum++;
    }

    setState(() {
      isLoading = false;
    });

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> loadImageData(int bid) async {
    if (!_imageMap.containsKey(bid)) {
      try {
        var response = await http.get(
            Uri.parse('http://10.0.2.2:9007/file-service/fileDownload/$bid'));
        if (response.statusCode == 200) {
          setState(() {
            _imageMap[bid] = response.bodyBytes;
          });
        } else {
          // Handle error case
        }
      } catch (e) {
        // Handle error case
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void processDelete(id) async {

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
      setState(() {
        _list.removeWhere((item) => item['id'] == id); // 삭제된 항목 제거
      });
    } catch (e) {
      print(e.toString());
    } finally {
      Navigator.pop(context); // 모달 창 닫기
    }


  }

  @override
  Widget build(BuildContext context) {
    var member = Provider.of<MemberModel>(context);
    bool isRole = member.role == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("상품 관리"),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(initialTabIndex: 3)),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          if (isRole)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemUploadPage()),
                ).then((value) {
                  setState(() {
                    loadData();
                  });
                });
              },
              icon: Icon(Icons.add_a_photo),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _list.length,
              itemBuilder: (context, index) {
                int bid = _list[index]['id'];
                if (!_imageMap.containsKey(bid)) {
                  loadImageData(bid);
                }

                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (_imageMap.containsKey(bid))
                                      Image.memory(
                                        _imageMap[bid]!,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      )
                                    else
                                      Image.asset(
                                        'assets/test1.gif',
                                        width: 150,
                                        height: 150,
                                      ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "상품명: ${_list[index]["itemName"]}",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            "상품설명: ${_list[index]["itemDescribe"]}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "상품종류: ${_list[index]["itemType"]}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "수량: ${_list[index]["ea"].toString()}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "가격: ${_list[index]["price"].toString()}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "할인률: ${_list[index]["discount"].toString()}%",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemDetailPage(id: _list[index]['id'],initialTabIndex: 0)));
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.greenAccent),
                                        padding:
                                        MaterialStateProperty.all<EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(horizontal: 10)),
                                      ),
                                      child: Text('바로가기'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImageUploadPage(
                                                id: _list[index]['id'],
                                                username: _list[index]['username'],
                                                itemType: _list[index]['itemType'],
                                                itemName: _list[index]['itemName']),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.pinkAccent),
                                        padding:
                                        MaterialStateProperty.all<EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(horizontal: 10)),
                                      ),
                                      child: Text("이미지 업로드"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemUpdatePage(id: _list[index]['id'])));
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.pinkAccent),
                                        padding:
                                        MaterialStateProperty.all<EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(horizontal: 10)),
                                      ),
                                      child: Text('수정'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("삭제 확인"),
                                            content: Text("삭제하시겠습니까?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context); // 닫기
                                                },
                                                child: Text("취소"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  processDelete(_list[index]['id']);
                                                  Navigator.pop(context); // 닫기
                                                },
                                                child: Text("삭제"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.pinkAccent),
                                        padding:
                                        MaterialStateProperty.all<EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(horizontal: 10)),
                                      ),
                                      child: Text('삭제'),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    title: Text(_list[index]['itemName']),
                    subtitle: Text(_list[index]['itemDescribe']),
                    trailing: Text(_list[index]["itemType"]),
                    leading: _imageMap.containsKey(bid)
                        ? Image.memory(
                      _imageMap[bid]!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/test1.gif',
                      width: 50,
                      height: 50,
                    ),
                  ),
                );
              },
            ),
          ),
          isLoading ? CircularProgressIndicator() : SizedBox(),
        ],
      ),
    );
  }
}
