import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kerly/my_homepage.dart';
import 'dart:convert';
import 'package:kerly/sign_up_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'changenotifier.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _id = "";
  String _pw = "";

  void _changeId() {
    setState(() {
      if (_idController.text.isEmpty) {
        return;
      }
      _id = _idController.text;
      _idController.text = "";
    });
  }

  void _changePw() {
    setState(() {
      if (_passwordController.text.isEmpty) {
        return;
      }
      _pw = _passwordController.text;
      _passwordController.text = "";
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    _id = _idController.text;
    _pw = _passwordController.text;

    if (_id.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("입력 오류"),
            content: Text("아이디를 입력해주세요."),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.pinkAccent,
                      ),
                    ),
                    child: Text("확인"),
                  ),
                ],
              ),
            ],
          );
        },
      );
      return;
    }


    if (_pw.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("입력 오류"),
            content: Text("비밀번호를 입력해주세요."),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.pinkAccent,
                      ),
                    ),
                    child: Text("확인"),
                  ),
                ],
              ),
            ],
          );
        },
      );
      return;
    }


    String url = "http://10.0.2.2:9007/auth-service/login";

    Map<String, String> body = {"username": _id, "password": _pw};

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(body),
    );

    try {
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        _id = data['result']['username'];
        _isLoading = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data['result']['token']);
      await prefs.setString("username", data['result']['username']);
      await prefs.setString("name", data['result']['name']);
      await prefs.setInt("role", data['result']['role']);

      _idController.text = "";
      _passwordController.text = "";
      print("로그인 성공");
      print(data['result']['username']);
      print(data['result']['name']);
      print(data['result']['token']);
      print(data['result']['role']);

      var member = Provider.of<MemberModel>(context, listen: false);
      member.login(data['result']['token'], data['result']['username'],
          data['result']['name'], data['result']['role']);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => MyHomePage(initialTabIndex: 3)),
      // );
      Navigator.pop(context);
    } catch (e) {
      print("로그인 실패: $e");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("로그인 실패"),
            content: Text("로그인에 실패했습니다.\n아이디나 비밀번호를 확인해주세요."),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.pinkAccent), // 원하는 색상으로 변경
                    ),
                    child: Text("확인"),
                  ),
                ],
              ),
            ],
          );
        },
      );


  } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? login_token;
  String? login_username;
  String? token;
  String? username;
  String? name;

  void _reset() {
    setState(() {
      _id = "";
      _pw = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: "ID",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "PW",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 45,
              ),
              ElevatedButton(
                onPressed: () {
                  _login();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.pinkAccent), // 원하는 색상으로 변경
                ),
                child: Text("로그인"),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => signuppage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey), // 원하는 색상으로 변경
                ),
                child: Text("회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
