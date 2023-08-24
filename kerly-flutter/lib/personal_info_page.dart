import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kerly/changenotifier.dart';
import 'package:kerly/password_update_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PersonalInfoPage extends StatefulWidget {
  final User loggedInUser; // 로그인한 사용자 정보를 저장하는 변수

  PersonalInfoPage({required this.loggedInUser});

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {

  final Future<SharedPreferences> future_prefs =
  SharedPreferences.getInstance();
  String token = "";
  String username = "";
  String name = "";
  String phoneNumber = "";
  String? address;
  String? detailInfo;


  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool _isLoading = false;


  SharedPreferences? sharedPreferences;
  // int selectedAddressIndex = 0;

  @override
  void initState() {
    super.initState();
    loadingPrefs();
    loadData();
    initSharedPreferences();
    usernameController = TextEditingController(text: widget.loggedInUser.username);
    nameController = TextEditingController(text: Provider
        .of<MemberModel>(context, listen: false)
        .name);

    phoneNumberController = TextEditingController();

    nameController.addListener(updateNameInSharedPreferences);

  }

  void updateNameInSharedPreferences() {
    final newUserName = nameController.text;
    sharedPreferences?.setString('name', newUserName);
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? address = Provider.of<AddressModel>(context, listen: false).address;
    String? detailInfo = Provider.of<AddressModel>(context, listen: false).detailInfo;


    address = sharedPreferences?.getString('selectedAddress');
    detailInfo = sharedPreferences?.getString('selectedDetailInfo');
    addressController.text = address! + detailInfo!;
    sharedPreferences?.setString('selectedAddress', address!);
    sharedPreferences?.setString('selectedDetailInfo', detailInfo!);
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    usernameController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void loadingPrefs() async {
    SharedPreferences prefs = await future_prefs;
    token = prefs.getString("token") ?? "";
    username = prefs.getString("username") ?? "";
    name = prefs.getString("name") ?? "";
    phoneNumber = prefs.getString("phoneNumber") ?? "";
    setState(() {
      usernameController.text = username;
      nameController.text = name;
      phoneNumberController.text = phoneNumber;
    });
  }

  Future<void> loadData() async {
    print(widget.loggedInUser.username);
    username = widget.loggedInUser.username;
    print("::::::::::::::::::::::::");
    setState(() {
      _isLoading = true;
    });

    try {
      String url = 'http://10.0.2.2:9007/member-service/username/$username';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        print(response.statusCode);
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));


      setState(() {
        usernameController.text = data['result']['username'];
        nameController.text = data['result']['name'];
        phoneNumberController.text = data['result']['phoneNumber'];
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var member = Provider.of<MemberModel>(context); // MemberModel 인스턴스 가져오기

    return _isLoading
        ? CircularProgressIndicator()
        : Scaffold(
      appBar: AppBar(
        title: Text('개인정보 수정'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300, // 네모난 칸의 너비
              height: 50, // 네모난 칸의 높이
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: usernameController,
                  enabled: false,
                  style: TextStyle(
                    color: Colors.black, // 검정색 글씨 색상
                    fontSize: 18, // 폰트 사이즈
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '아이디',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(
                    color: Colors.black, // 검정색 글씨 색상
                    fontSize: 18, // 폰트 사이즈
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '이름',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: phoneNumberController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: "휴대전화번호",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    final digits = value.replaceAll(RegExp(r'\D'), '');
                    final formattedText = digits.padRight(11);
                    final unformattedText = digits.replaceAll(' ', '');
                    if (value != formattedText) {
                      phoneNumberController.value = TextEditingValue(
                        text: formattedText,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: formattedText.length),
                        ),
                      );
                    }
                    if (phoneNumberController.text != unformattedText) {
                      phoneNumberController.text = unformattedText;
                      phoneNumberController.selection = TextSelection.fromPosition(
                        TextPosition(offset: unformattedText.length),
                      );
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color: Colors.black, // 검정색 글씨 색상
                    fontSize: 18, // 폰트 사이즈
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '비밀번호',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Container(
            //   width: 300,
            //   height: 55,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey),
            //     borderRadius: BorderRadius.circular(4.0),
            //   ),
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: 8.0,
            //       vertical: MediaQuery.of(context).size.width <= 300 ? 10.0 : 0.0, // MediaQuery를 사용하여 화면의 너비 가져오기
            //     ),
            //     child: Text(
            //       addressController.text,
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 18,
            //       ),
            //       maxLines: null, // 추가된 코드
            //       overflow: TextOverflow.visible,
            //     ),
            //   ),
            // ),
            // Container(
            //   width: 300,
            //   height: 55,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey),
            //     borderRadius: BorderRadius.circular(4.0),
            //   ),
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: 8.0,
            //       vertical: MediaQuery.of(context).size.width <= 300 ? 10.0 : 0.0,
            //     ),
            //     child: TextField(
            //       readOnly: true, // 입력 막기 (텍스트 선택은 가능)
            //       controller: addressController,
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 18,
            //       ),
            //       maxLines: null,
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //         hintText: '주소', // 힌트 텍스트로 "주소" 표시
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  readOnly: true,
                  controller: addressController,
                  style: TextStyle(
                    color: Colors.black, // 검정색 글씨 색상
                    fontSize: 18, // 폰트 사이즈
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '주소',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (currentPasswordController.text.isEmpty) {
                  // 패스워드가 입력되지 않은 경우
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "패스워드를 입력해주세요.",
                        style: TextStyle(fontSize: 20),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                updateMemberInfo(context);

              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.pinkAccent),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 60)),
              ),
              child: Text('확인'),
            ),
            ElevatedButton(
              onPressed: () {
                User loggedInUser = User(
                  username: '${member.username}',
                  name: '${member.name}',
                  phoneNumber: '${phoneNumber}',
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordUpdatePage(loggedInUser: loggedInUser),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.greenAccent),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 33)),
              ),
              child: Text('비밀번호 수정'),

            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateMemberInfo(BuildContext context) async {

    String password = currentPasswordController.text;
    String username = usernameController.text;
    String name = nameController.text;
    String phoneNumber = phoneNumberController.text;

    if (phoneNumber.length != 11) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("수정 실패"),
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
      return; // 수정 중지
    }

    setState(() {
      _isLoading = true;
    });

    String url = "http://10.0.2.2:9007/member-service/user/username";

    try {
      Map<String, dynamic> body = {
        "username": username,
        "name": name,
        "phoneNumber": phoneNumber,
        "password": password,
      };

      final response = await http.put(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": token,
          },
          body: jsonEncode(body));

      if (response.statusCode != 200) {
        print(response.statusCode);
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        Provider.of<MemberModel>(context, listen: false).changeName(name);
      });

      if (data['result']['password'] == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "회원정보 수정 성공",
              style: TextStyle(fontSize: 20),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "패스워드가 틀렸습니다.",
              style: TextStyle(fontSize: 20),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(

            "수정 실패",
            style: TextStyle(fontSize: 20),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return; // To prevent screen transition, return is added
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}