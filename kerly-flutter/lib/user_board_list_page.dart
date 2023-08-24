import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kerly/board_detail_page.dart';

class UserBoardListPage extends StatefulWidget {
  final int id;
  const UserBoardListPage({Key? key, required this.id}) : super(key: key);

  @override
  _UserBoardListPageState createState() => _UserBoardListPageState();
}

class _UserBoardListPageState extends State<UserBoardListPage> {
  late List<dynamic> boardItems;
  late List<dynamic> boardItems2;
  bool isLoading = false;
  String? subject;
  String? content;
  String formattedCreateDate ='';
  int? index;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    boardItems = [];
    boardItems2 = [];
    boardAll();
    boardAll2();
  }

  Future<void> boardAll2() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      String url = 'http://10.0.2.2:9007/board-service/admin/all';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> result = data['result'];

        for (var item in result) {
          String subject = item['subject'];
          //     print(subject);
        }

        setState(() {
          boardItems2 = List<dynamic>.from(result);
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> boardAll() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      String url = 'http://10.0.2.2:9007/board-service/all';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> result = data['result'];

        for (var item in result) {
          String subject = item['subject'];
          //     print(subject);
        }

        setState(() {
          boardItems = List<dynamic>.from(result);
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: boardItems.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
          height: 1,
        ),
        itemBuilder: (context, index) {
          String subject = boardItems[index]["subject"].toString();
          String content = boardItems[index]["content"].toString();
          DateTime createDate = DateTime.parse(boardItems[index]["createDate"]);
          formattedCreateDate =
              DateFormat('yyyy년 MM월 dd일').format(createDate);

          // 텍스트 길이 제한
          final int maxTextLength = 20; // 최대 글자 수
          if (subject.length > maxTextLength) {
            subject = subject.substring(0, maxTextLength) + "...";
          }
          if (content.length > maxTextLength) {
            content = content.substring(0, maxTextLength) + "...";
          }
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoardDetailPage(id: boardItems[index]["id"]),
                  ),
              );
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(boardItems[index]["id"].toString()+". "+subject),
                SizedBox(width: 8), // 원하는 만큼의 간격 설정
                Container(
                  padding: EdgeInsets.only(left: 8), // 원하는 만큼의 간격 설정
                  child: Text(
                    content,
                  ),
                ),
              ],
            ),
            subtitle: Text(formattedCreateDate),
          );
        },
      ),
    );
  }
}