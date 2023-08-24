import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kerly/user_reply_update_page.dart';
import 'package:provider/provider.dart';

import 'changenotifier.dart';

class UserReplyListPage extends StatefulWidget {
  final int id;

  UserReplyListPage(this.id, {Key? key}) : super(key: key);

  @override
  _UserReplyListPageState createState() => _UserReplyListPageState();

  static void loadData({required bool resetPage}) {
    loadData(resetPage: resetPage);
  }
}

class _UserReplyListPageState extends State<UserReplyListPage> {
  TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int pageNum = 0;
  List<dynamic> _list = [];
  bool isLoading = false;
  String content = "";
  int bid = 0;
  String productName = "";

  @override
  void initState() {
    super.initState();
    _list = [];

    loadData(resetPage: true);
    loadData4();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadData();
      }
    });
    loadData(resetPage: true);
  }

  Future<void> loadData({bool resetPage = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    if (resetPage) {
      pageNum = 0; // 페이지 번호를 초기화합니다.
      _list.clear(); // 기존 검색 결과를 초기화합니다.
    }

    try {
      String url =
          'http://10.0.2.2:9007/reply-service/replys/bid?bid=${widget.id}&pageNum=${pageNum}';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          _list.addAll(result); // 수정됨: 추가 데이터를 리스트에 추가합니다.
          pageNum++;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> loadData4() async {
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
        bid = data['result']['id'];
        productName = data['result']['itemName'];
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> replyDelete({required int id}) async {
    try {
      String url = 'http://10.0.2.2:9007/reply-service/delete';

      Map<String, dynamic> body = {"id": id};

      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        setState(() {
          pageNum = 0;
          _list.clear(); // pageNum을 0으로 초기화합니다.
        });
        // 댓글 삭제 후 UserReplyListPage의 loadData()를 호출합니다.
        loadData();
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          isLoading ? CircularProgressIndicator() : SizedBox(height: 20,),
          TextField(
            controller: _replyController,
            decoration: InputDecoration(
              labelText: "후기",
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              _replyinsert();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.pinkAccent),
            ),
            child: Text("확인"),
          ),
          SizedBox(height: 30,),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _list.length,
              itemBuilder: (context, index) {
                bool isOwner = _list[index]["username"] ==
                    Provider.of<MemberModel>(context, listen: false)
                        .username;

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            _list[index]["username"],
                            style: TextStyle(fontSize: 25),
                          ),
                          content: Text(
                            _list[index]["content"],
                            style: TextStyle(fontSize: 20),
                          ),
                          actions: [
                            if (isOwner) // 소유자인 경우에만 표시
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserReplyUpdatePage(
                                        id: _list[index]["id"],
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.pinkAccent),
                                ),
                                child: Text("수정"),
                              ),
                            if (isOwner) // 소유자인 경우에만 표시
                              ElevatedButton(
                                onPressed: () {
                                  replyDelete(id: _list[index]["id"]);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.grey),
                                ),
                                child: Text("삭제"),
                              ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                    key: ValueKey(_list[index]["id"]),
                    title: Text(_list[index]["content"]),
                    subtitle: Text(_list[index]["username"]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _replyinsert() async {
    String url = "http://10.0.2.2:9007/reply-service/user/replys";

    Map<String, dynamic> body = {
      "username": Provider.of<MemberModel>(context, listen: false).username,
      "content": _replyController.text,
      "bid": bid,
      "productName": productName
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(body),
    );

    try {
      if (response.statusCode != 201 && response.statusCode != 200) {
        print(response.statusCode);
        print("실패했습니다.");
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      print("작성 성공");

      // 댓글 작성 후 텍스트 필드를 초기화합니다.
      _replyController.clear();
      // 데이터를 다시 불러와서 페이지를 새로고침합니다.
      setState(() {
        _list.clear();
        pageNum = 0;
        loadData();
      });
    } catch (e) {
      print(e.toString());
      print("작성 실패");
    }
  }
}
