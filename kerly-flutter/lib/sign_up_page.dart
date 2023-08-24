import 'dart:convert';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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

  String _isUsernameAvailable = "";
  bool _isCorporateMember = false;
  int _role = 0;

  bool _isPhoneNumberValid = true;

  Future<void> _signup() async {

    String username = _signupidController.text;
    await _checkUsernameAvailability(username);

    _signupid = _signupidController.text;
    _signupname = _signupnameController.text;
    _signuppw = _signuppasswordController.text;
    _signuppw2 = _signuppassword2Controller.text;
    _phoneNumber = _signupphoneNumberController.text;


    if (_signupid.isEmpty || _signupname.isEmpty || _signuppw.isEmpty || _signuppw2.isEmpty || _phoneNumber.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("입력 오류"),
            content: Text("모든 항목을 입력해주세요."),
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
      return; // 회원 가입 요청을 하지 않고 함수 종료
    }

    String url = "http://10.0.2.2:9007/auth-service/create";

    Map<String, String> body = {
      "username" : _signupid,
      "name" : _signupname,
      "password" : _signuppw,
      "password2" : _signuppw2,
      "phoneNumber" : _phoneNumber,
      "role" : _role.toString()
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
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.pinkAccent), // 원하는 색상으로 변경
                ),
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

  Future<void> _checkUsernameAvailability(String username) async {
    String url = "http://10.0.2.2:9007/auth-service/checkid?username=${username}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String result = response.body;
      setState(() {
        _isUsernameAvailable = result;
      });
    } else {
      throw Exception('사용자명 가용성 확인에 실패했습니다');
    }
  }

  void _checkPhoneNumberValidity(String phoneNumber) {
    if (phoneNumber.length != 11 || !phoneNumber.contains(RegExp(r'^\d+$'))) {
      setState(() {
        _isPhoneNumberValid = false;
      });
    } else {
      setState(() {
        _isPhoneNumberValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("회원가입"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextField(
                controller: _signupidController,
                decoration: InputDecoration(
                  labelText: "아이디",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
                onChanged: (value) {
                  _checkUsernameAvailability(value);
                },
              ),
              Text(
                _isUsernameAvailable,
                style: TextStyle(
                  color: _isUsernameAvailable == "사용 가능" ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(height: 10,),
              TextField(
                controller: _signupnameController,
                decoration: InputDecoration(
                  labelText: "이름",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30,),
              TextField(
                controller: _signuppasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30,),
              TextField(
                controller: _signuppassword2Controller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호 재확인",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30,),
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

                  _checkPhoneNumberValidity(_signupphoneNumberController.text);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                ],
                keyboardType: TextInputType.phone,
              ),
              // 유효성 검사 결과에 따른 안내 문구 표시
              !_isPhoneNumberValid
                  ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "올바른 11자리 숫자를 입력하세요.",
                  style: TextStyle(color: Colors.red),
                ),
              )
                  : SizedBox(height: 0),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCheckBox(
                    value: _isCorporateMember,
                    checkedFillColor: Colors.pinkAccent,
                    checkBoxSize: 24,
                    onChanged: (value) {
                      setState(() {
                        _isCorporateMember = value ?? false;
                        _role = 1;
                      });
                    },
                  ),
                  Text("기업회원 가입"),
                ],
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: !_isPhoneNumberValid ? null : () {
                  _signup();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.pinkAccent),
                ),
                child: Text("가입하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
