// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:kerly/changenotifier.dart';
// import 'package:kerly/notcomplete.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class PasswordUpdatePage extends StatefulWidget {
//   final User loggedInUser; // 로그인한 사용자 정보를 저장하는 변수
//
//   PasswordUpdatePage({required this.loggedInUser});
//
//   @override
//   _PasswordUpdatePageState createState() => _PasswordUpdatePageState();
// }
//
// class _PasswordUpdatePageState extends State<PasswordUpdatePage> {
//   final Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();
//   String token = "";
//   String username = "";
//
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController currentOrgPasswordController = TextEditingController();
//   TextEditingController currentPasswordController = TextEditingController();
//   TextEditingController currentPasswordController2 = TextEditingController();
//
//   bool _isLoading = false;
//
//   SharedPreferences? sharedPreferences;
//   int selectedAddressIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     loadingPrefs();
//     loadData();
//     initSharedPreferences();
//     usernameController = TextEditingController(text: widget.loggedInUser.username);
//   }
//
//   void initSharedPreferences() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     selectedAddressIndex = sharedPreferences?.getInt('addressIndex') ?? 0;
//   }
//
//   @override
//   void dispose() {
//     currentPasswordController.dispose();
//     usernameController.dispose();
//     super.dispose();
//   }
//
//   void loadingPrefs() async {
//     SharedPreferences prefs = await futurePrefs;
//     token = prefs.getString("token") ?? "";
//     username = prefs.getString("username") ?? "";
//     setState(() {
//       usernameController.text = username;
//     });
//   }
//
//   Future<void> loadData() async {
//     print(widget.loggedInUser.username);
//     username = widget.loggedInUser.username;
//     print("::::::::::::::::::::::::");
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       String url = 'http://10.0.2.2:9007/member-service/username/$username';
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//         },
//       );
//
//       if (response.statusCode != 200) {
//         print(response.statusCode);
//         throw Exception();
//       }
//
//       Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
//
//       setState(() {
//         usernameController.text = data['result']['username'];
//       });
//     } catch (e) {
//       print(e.toString());
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var member = Provider.of<MemberModel>(context); // MemberModel 인스턴스 가져오기
//
//     return _isLoading
//         ? NotComplete()
//         : Scaffold(
//       appBar: AppBar(
//         title: Text('비밀번호 수정'),
//         backgroundColor: Colors.pinkAccent,
//         automaticallyImplyLeading: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 300, // 네모난 칸의 너비
//               height: 50, // 네모난 칸의 높이
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: TextField(
//                   controller: usernameController,
//                   enabled: false,
//                   style: TextStyle(
//                     color: Colors.black, // 검정색 글씨 색상
//                     fontSize: 18, // 폰트 사이즈
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: '아이디',
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Container(
//               width: 300,
//               height: 50,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: TextField(
//                   controller: currentOrgPasswordController,
//                   obscureText: true,
//                   style: TextStyle(
//                     color: Colors.black, // 검정색 글씨 색상
//                     fontSize: 18, // 폰트 사이즈
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: '기존 비밀번호',
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Container(
//               width: 300,
//               height: 50,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: TextField(
//                   controller: currentPasswordController,
//                   obscureText: true,
//                   style: TextStyle(
//                     color: Colors.black, // 검정색 글씨 색상
//                     fontSize: 18, // 폰트 사이즈
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: '변경할 비밀번호',
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Container(
//               width: 300,
//               height: 50,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: TextField(
//                   controller: currentPasswordController2,
//                   obscureText: true,
//                   style: TextStyle(
//                     color: Colors.black, // 검정색 글씨 색상
//                     fontSize: 18, // 폰트 사이즈
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: '변경할 비밀번호 확인',
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 if (currentOrgPasswordController.text.isEmpty ||
//                     currentPasswordController.text.isEmpty ||
//                     currentPasswordController2.text.isEmpty) {
//                   // 패스워드가 입력되지 않은 경우
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         "패스워드를 입력해주세요.",
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       duration: Duration(seconds: 3),
//                     ),
//                   );
//                   return;
//                 }
//                 updatePasswordInfo(context);
//               },
//               style: ButtonStyle(
//                 backgroundColor:
//                 MaterialStateProperty.all<Color>(Colors.pinkAccent),
//                 padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                     EdgeInsets.symmetric(horizontal: 60)),
//               ),
//               child: Text('확인'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> updatePasswordInfo(BuildContext context) async {
//     String orgPassword = currentOrgPasswordController.text;
//     String password = currentPasswordController.text;
//     String password2 = currentPasswordController2.text;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     String url = "http://10.0.2.2:9007/member-service/user/password";
//
//     try {
//       Map<String, dynamic> body = {
//         "username": username,
//         "orgPassword": orgPassword,
//         "password": password,
//         "password2": password2,
//       };
//
//       final response = await http.put(Uri.parse(url),
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           },
//           body: jsonEncode(body));
//
//       if (response.statusCode != 200) {
//         print(response.statusCode);
//         throw Exception();
//       }
//
//       Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
//      print(data['result']);
//
//      if(data["result"]=="성공"){
//        Navigator.pop(context);
//      }
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "회원정보 수정 실패",
//             style: TextStyle(fontSize: 20),
//           ),
//           duration: Duration(seconds: 3),
//         ),
//       );
//       return;
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }
//
// class User {
//   final String username;
//   final String name;
//   final String phoneNumber;
//
//   User({
//     required this.username,
//     required this.name,
//     required this.phoneNumber,
//   });
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kerly/changenotifier.dart';
import 'package:kerly/notcomplete.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PasswordUpdatePage extends StatefulWidget {
  final User loggedInUser; // 로그인한 사용자 정보를 저장하는 변수

  PasswordUpdatePage({required this.loggedInUser});

  @override
  _PasswordUpdatePageState createState() => _PasswordUpdatePageState();
}

class _PasswordUpdatePageState extends State<PasswordUpdatePage> {
  final Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();
  String token = "";
  String username = "";

  TextEditingController usernameController = TextEditingController();
  TextEditingController currentOrgPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController currentPasswordController2 = TextEditingController();

  bool _isLoading = false;

  SharedPreferences? sharedPreferences;
  int selectedAddressIndex = 0;

  @override
  void initState() {
    super.initState();
    loadingPrefs();
    loadData();
    initSharedPreferences();
    usernameController = TextEditingController(text: widget.loggedInUser.username);
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    selectedAddressIndex = sharedPreferences?.getInt('addressIndex') ?? 0;
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void loadingPrefs() async {
    SharedPreferences prefs = await futurePrefs;
    token = prefs.getString("token") ?? "";
    username = prefs.getString("username") ?? "";
    setState(() {
      usernameController.text = username;
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
        ? NotComplete()
        : Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 수정'),
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
                  controller: currentOrgPasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color: Colors.black, // 검정색 글씨 색상
                    fontSize: 18, // 폰트 사이즈
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '기존 비밀번호',
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
                  controller: currentPasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color: Colors.black, // 검정색 글씨 색상
                    fontSize: 18, // 폰트 사이즈
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '변경할 비밀번호',
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
                  controller: currentPasswordController2,
                  obscureText: true,
                  style: TextStyle(
                    color: Colors.black, // 검정색 글씨 색상
                    fontSize: 18, // 폰트 사이즈
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '변경할 비밀번호 확인',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (currentOrgPasswordController.text.isEmpty ||
                    currentPasswordController.text.isEmpty ||
                    currentPasswordController2.text.isEmpty) {
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
                updatePasswordInfo(context);
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.pinkAccent),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 60)),
              ),
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updatePasswordInfo(BuildContext context) async {
    String orgPassword = currentOrgPasswordController.text;
    String password = currentPasswordController.text;
    String password2 = currentPasswordController2.text;

    setState(() {
      _isLoading = true;
    });


    if (password != password2) {
      // 변경할 비밀번호1과 2가 일치하지 않는 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "변경할 비밀번호가 일치하지 않습니다.",
            style: TextStyle(fontSize: 20),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String url = "http://10.0.2.2:9007/member-service/user/password";

    try {
      Map<String, dynamic> body = {
        "username": username,
        "orgPassword": orgPassword,
        "password": password,
        "password2": password2,
      };

      final response = await http.put(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode(body));

      if (response.statusCode != 200) {
        print(response.statusCode);
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data['result']);

      if (data["result"] == "성공") {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: Text('비밀번호가 변경되었습니다.'),
              actions: [
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else if (data["result"] == "비밀번호 틀림") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "기존 비밀번호가 일치하지 않습니다.",
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
            "회원정보 수정 실패",
            style: TextStyle(fontSize: 20),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class User {
  final String username;
  final String name;
  final String phoneNumber;

  User({
    required this.username,
    required this.name,
    required this.phoneNumber,
  });
}