import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kerly/changenotifier.dart';
import 'package:kerly/my_homepage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SlideImageAdd extends StatefulWidget {
  const SlideImageAdd({Key? key}) : super(key: key);

  @override
  State<SlideImageAdd> createState() => _SlideImageAddState();
}

class _SlideImageAddState extends State<SlideImageAdd> {
  TextEditingController urlController = TextEditingController();

  // List<dynamic> imageUrls = [];
  late List<dynamic> imageUrls;
  String imageUrl = "";
  int id = 0;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    imageUrls = [];
    loadData();
  }


  Future<void> _urlUpload() async {
    imageUrl = urlController.text;

    if (imageUrl.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('URL을 입력해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    String url = 'http://10.0.2.2:9007/file-service/urlUpload';

    Map<String, dynamic> body = {
      "username": Provider
          .of<MemberModel>(context, listen: false)
          .username,
      "imageUrl": imageUrl,
      "id": id,
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
      print("작성 성공");

      loadData();

      // 댓글 작성 후 텍스트 필드를 초기화합니다.
      urlController.clear();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('url이 200자를 초과하였습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      print(e.toString());
      print("작성 실패");

    } finally {
      setState(() {
        imageUrl = urlController.text;
      });
    }
  }

  Future<void> loadData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      String url = 'http://10.0.2.2:9007/file-service/all';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      print(":::::::::1111111111:::::::::::::");

      if (response.statusCode == 200) {
        // List<dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
        Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> result = data['result'];
        setState(() {
          // imageUrls.addAll(result); // 수정됨: 추가 데이터를 리스트에 추가합니다.
          imageUrls = List<dynamic>.from(result);
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


  void urlDelete(index) async {
    setState(() {
      isLoading = true;
    });

    id = imageUrls[index]["id"];

    String url = "http://10.0.2.2:9007/file-service/urlDelete";
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

      Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        imageUrls.removeAt(index);
      });

      loadData();


    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이미지'),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(initialTabIndex: 0)),
            );
          },
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 30,),
          Text(
            '           url 글자 수는 200까지 입니다.\n(1200x628 크기의 이미지만 올려주세요.)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: '이미지 URL',
              ),
            ),
          ),
          SizedBox(height: 25,),
          ElevatedButton(
            onPressed: _urlUpload,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.pinkAccent
              ),
            ),
            child: Text('이미지 추가'),
          ),
          SizedBox(height: 40,),
          Expanded(
            child: ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (BuildContext context, int index) {
                final imageUrl = imageUrls[index]["imageUrl"];
                return ListTile(
                  title: Text(imageUrls[index]["id"].toString()),
                  leading: Image.network(
                    imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.fitWidth,),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => urlDelete(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}