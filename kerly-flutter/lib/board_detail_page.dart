import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Board boardFromJson(String str) => Board.fromJson(json.decode(str));

String boardToJson(Board data) => json.encode(data.toJson());

class Board {
  int id;
  String subject;
  String content;
  DateTime createDate;
  DateTime updateDate;
  String name;
  String username;

  Board({
    required this.id,
    required this.subject,
    required this.content,
    required this.createDate,
    required this.updateDate,
    required this.name,
    required this.username,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
    id: json["id"],
    subject: json["subject"],
    content: json["content"],
    createDate: DateTime.parse(json["createDate"]),
    updateDate: DateTime.parse(json["updateDate"]),
    name: json["name"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subject": subject,
    "content": content,
    "createDate": "${createDate.year.toString().padLeft(4, '0')}-${createDate.month.toString().padLeft(2, '0')}-${createDate.day.toString().padLeft(2, '0')}",
    "updateDate": "${updateDate.year.toString().padLeft(4, '0')}-${updateDate.month.toString().padLeft(2, '0')}-${updateDate.day.toString().padLeft(2, '0')}",
    "name": name,
    "username": username,
  };
}

class BoardDetailPage extends StatefulWidget {
  final int id;
  
  const BoardDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {

  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool isLoading = false;

  int _id = 0;
  String _username = "";
  String _name = "";
  String _createDate = "";
  String _updateDate = "";
  String _subject = "";
  String _content = "";
  int _bid = 0;

  late TabController _tabController;

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    print(widget.id);

    try {
      String url = 'http://10.0.2.2:9007/board-service/id/${widget.id}';

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
        _username = data['result']['username'] ?? '';
        _name = data['result']['name'] ?? '';
        _createDate = data['result']['createDate'] ?? '';
        _updateDate = data['result']['updateDate'] ?? '';
        _subject = data['result']['subject'] ?? '';
        _content = data['result']['content'] ?? '';
        _bid = _id;
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 158.0),
            child: const Text('Q&A'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _subject.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter, // 컨테이너를 위쪽으로 정렬
                child: Container(
                  width: MediaQuery.of(context).size.width, // 핸드폰의 가로 길이로 설정
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _content.toString(),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}