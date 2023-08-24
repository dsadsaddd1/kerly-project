import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kerly/changenotifier.dart';
import 'package:kerly/item_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BoardInsertPage extends StatefulWidget {
  final int id;
  final TabController tabController;

  const BoardInsertPage({Key? key, required this.tabController, required this.id}) : super(key: key);

  @override
  State<BoardInsertPage> createState() => _BoardInsertPageState();
}

class _BoardInsertPageState extends State<BoardInsertPage> {
  late TextEditingController _subjectController;
  late TextEditingController _contentController;
  String _subject = "";
  String _content = "";

  bool isLoading = false;

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
        _bid = data['result']['id'];
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }






  Future<void> _boardInsert() async {
    _subject = _subjectController.text;
    _content = _contentController.text;

    String url = "http://10.0.2.2:9007/board-service/write";

    Map<String, dynamic> body = {
      "username": Provider.of<MemberModel>(context, listen: false).username,
      "content": _content,
      "subject": _subject,
      "bid" : _bid,
      "name": Provider.of<MemberModel>(context, listen: false).name
    };

    final response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: jsonEncode(body));

    try {
      if (response.statusCode != 201 && response.statusCode != 200) {
     //   print(response.statusCode);
        print("실패했습니다.");
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      print("작성 성공");

      _subjectController.clear();
      _contentController.clear();
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ItemDetailPage(id: _bid, initialTabIndex: 2)),
      );


      setState(() {

      });

    } catch (e) {
      print(e.toString());
      print("작성 실패");
    } finally {
      setState(() {
        _subject = _subjectController.text;
        _content = _contentController.text;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    loadData();
    _subjectController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 작성'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: '제목',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '내용',
              ),
              // maxLines: 5,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _boardInsert,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.pinkAccent),
              ),
              child: const Text('작성'),
            ),
          ],
        ),
      ),
    );
  }
}
