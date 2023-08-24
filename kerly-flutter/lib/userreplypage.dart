import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UserReplyPage extends StatefulWidget {
  final int id;

  const UserReplyPage(this.id, {Key? key}) : super(key: key);

  @override
  State<UserReplyPage> createState() => _UserReplyPageState();
}

class _UserReplyPageState extends State<UserReplyPage> {
  TextEditingController _replyController = TextEditingController();

  String _reply = "";

  bool isLoading = false;
  int _bid = 0;
  String _productName = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String url = 'http://10.0.2.2:9007/item/id/${widget.id}';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        _bid = data['result']['id'];
        _productName = data['result']['itemName'];
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> _replyinsert() async {
    _reply = _replyController.text;

    String url = "http://10.0.2.2:9007/reply/user/replys";

    Map<String, dynamic> body = {
      "username": "m001",
      "content": _reply,
      "bid": _bid,
      "productName": _productName
    };

    final response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: jsonEncode(body));

    try {
      if (response.statusCode != 201 && response.statusCode != 200) {
        print(response.statusCode);
        print("실패했습니다.");
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      print(data);
      print("작성 성공");
    } catch (e) {
      print(e.toString());
      print("작성 실패");
    } finally {
      setState(() {
        _reply = _replyController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _replyController,
            decoration: InputDecoration(
              labelText: "후기",
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 40),
          ),
          ElevatedButton(
              onPressed: () {
                _replyinsert();
              },
              child: Text("확인")),
          SizedBox(
            height: 10,
          ),
          Text(
            "$_reply",
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
