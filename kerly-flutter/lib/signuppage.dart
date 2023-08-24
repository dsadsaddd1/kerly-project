import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kerly/phone_page.dart';

class signuppage extends StatefulWidget {
  const signuppage({Key? key}) : super(key: key);

  @override
  State<signuppage> createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  TextEditingController _signupidController = TextEditingController();
  TextEditingController _signuppasswordController = TextEditingController();
  TextEditingController _signuppassword2Controller = TextEditingController();
  TextEditingController _signupnameController = TextEditingController();
  TextEditingController _signupphoneNumberController = TextEditingController();

  String _signupid = "";
  String _signuppw = "";
  String _signuppw2 = "";
  String _signupname = "";
  String _phoneNumber = "";

  Future<void> _signup() async {
    _signupid = _signupidController.text;
    _signupname = _signupnameController.text;
    _signuppw = _signuppasswordController.text;
    _signuppw2 = _signuppassword2Controller.text;
    _phoneNumber = _signupphoneNumberController.text;

    if (_phoneNumber.length != 11) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("회원가입 실패"),
            content: Text("핸드폰 번호는 11자리여야 합니다."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
      return; // 회원가입 중지
    }

    String url = "http://10.0.2.2:9007/auth-service/create";

    Map<String, String> body = {
      "username" : _signupid,
      "name" : _signupname,
      "password" : _signuppw,
      "password2" : _signuppw2,
      "phoneNumber" : _phoneNumber
    };

    final response = await http.post(Uri.parse(url),
        headers: {"Content-type" : "application/json"},
        body : jsonEncode(body)
    );

    try {
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        _signupid = data['result']['username'];
        _signupname = data['result']['name'];
        _signupidController.text = "";
        _signupnameController.text = "";
        _signuppasswordController.text = "";
        _signuppassword2Controller.text = "";
        _signupphoneNumberController.text = "";
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("회원가입 성공"),
            content: Text("회원가입 성공."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // 이전 페이지로 돌아가기
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("회원가입 실패"),
            content: Text("회원가입 실패. 다시 시도해주세요."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
    }
  }

  void _reset() {
    setState(() {
      _signupid = "";
      _signuppw = "";
      _signupname = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _signupidController,
                decoration: InputDecoration(
                  labelText: "아이디",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _signupnameController,
                decoration: InputDecoration(
                  labelText: "이름",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _signuppasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _signuppassword2Controller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호 재확인",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _signupphoneNumberController,
                decoration: InputDecoration(
                  labelText: "휴대전화번호",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
                onChanged: (value) {
                  var digits = value.replaceAll(RegExp(r'\D'), '');
                  if (digits.length > 11) {
                    digits = digits.substring(0, 11);
                  }
                  final formattedText = digits.padRight(11);
                  final unformattedText = digits.replaceAll(' ', '');
                  if (value != formattedText) {
                    _signupphoneNumberController.value = TextEditingValue(
                      text: formattedText,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: formattedText.length),
                      ),
                    );
                  }
                  if (_signupphoneNumberController.text != unformattedText) {
                    _signupphoneNumberController.text = unformattedText;
                    _signupphoneNumberController.selection = TextSelection.fromPosition(
                      TextPosition(offset: unformattedText.length),
                    );
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                ],
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  _signup();
                },
                child: Text("가입하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
