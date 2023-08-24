import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kerly/changenotifier.dart';
import 'package:kerly/my_homepage.dart';
import 'package:kerly/sql/address_crud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteServicePage extends StatefulWidget {
  final String username;

  const DeleteServicePage({Key? key, required this.username}) : super(key: key);

  @override
  _DeleteServicePageState createState() => _DeleteServicePageState();
}

class _DeleteServicePageState extends State<DeleteServicePage> {
  String password = '';
  bool passwordMatched = false;
  TextEditingController _passwordController = TextEditingController();


  Future<void> deleteAccount() async {
    // 회원 탈퇴 요청을 보내는 로직 구현
    // 이 예제에서는 POST 메서드를 사용하여 JSON 형태의 요청을 보냅니다.
    // 서버로부터 응답을 받고, 응답 내용에 따라 처리합니다.
    password = _passwordController.text;

    final url = Uri.parse(
        'http://10.0.2.2:9007/member-service/delete'); // 백엔드 엔드포인트 URL로 수정해야 합니다.
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'password': password,
      'username': widget.username
    }); // 비밀번호를 JSON 형태로 보냅니다.

    final response = await http.delete(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final result = responseData['result'];


      if (result == '삭제에 성공했습니다.') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", "");
        await prefs.setString("username", "");
        await prefs.setString("name", "");
        await prefs.setInt('selectedAddressIndex', -1);
        await prefs.setString('address', "");
        await prefs.setString('detailInfo', "");
        await prefs.setInt('role', 0);
        await prefs.setString('selectedAddress', "");
        await prefs.setString('selectedDetailInfo', "");

        await SqlAddressCrudRepository.deleteAll();

        var member = Provider.of<MemberModel>(context, listen: false);

        member.allClear();

        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('회원 탈퇴'),
              content: Text('회원 탈퇴가 완료되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close the dialog
                    // 회원 탈퇴 이후에 수행할 작업 구현
                    // 예: 로그인 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MyHomePage(initialTabIndex: 0,)),
                    );
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      }
    }

    if (response.statusCode != 200) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('회원 탈퇴'),
            content: Text('회원 탈퇴에 실패했습니다. 비밀번호를 확인해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Close the dialog
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 탈퇴'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '비밀번호를 입력하세요',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text('회원 탈퇴'),
                        content: Text('정말 회원 탈퇴하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop(); // Close the dialog
                            },
                            child: Text('취소'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteAccount(); // 회원 탈퇴 진행
                              Navigator.of(dialogContext).pop(); // Close the dialog
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.pinkAccent, // 원하는 색상으로 변경
                  ),
                ),
                child: Text('확인'),
              ),



              //
              // ElevatedButton(
              //   onPressed: () {
              //     deleteAccount();
              //   },
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all<Color>(
              //         Colors.pinkAccent), // 원하는 색상으로 변경
              //   ),
              //   child: Text('확인'),
              // ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}