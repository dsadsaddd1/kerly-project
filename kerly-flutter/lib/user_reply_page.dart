// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'changenotifier.dart';
// import 'item_detail_page.dart';
//
// class UserReplyPage extends StatefulWidget {
//   final int id;
//
//   const UserReplyPage(this.id, {Key? key}) : super(key: key);
//
//   @override
//   State<UserReplyPage> createState() => _UserReplyPageState();
// }
//
// class _UserReplyPageState extends State<UserReplyPage> {
//   TextEditingController _replyController = TextEditingController();
//
//   String _reply = "";
//
//   bool isLoading = false;
//   int _bid = 0;
//   String _productName = "";
//
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }
//
//   Future<void> loadData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       String url = 'http://10.0.2.2:9007/item-service/id/${widget.id}';
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception();
//       }
//
//       Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
//
//       setState(() {
//         _bid = data['result']['id'];
//         _productName = data['result']['itemName'];
//       });
//
//     } catch (e) {
//       print(e);
//     } finally {
//       isLoading = false;
//     }
//   }
//
//   Future<void> _replyinsert() async {
//     _reply = _replyController.text;
//
//     String url = "http://10.0.2.2:9007/reply-service/user/replys";
//
//     Map<String, dynamic> body = {
//       "username": Provider.of<MemberModel>(context, listen: false).username,
//       "content": _reply,
//       "bid": _bid,
//       "productName": _productName
//     };
//
//     final response = await http.post(Uri.parse(url),
//         headers: {"Content-type": "application/json"}, body: jsonEncode(body));
//
//     try {
//       if (response.statusCode != 201 && response.statusCode != 200) {
//         print(response.statusCode);
//         print("실패했습니다.");
//         throw Exception();
//       }
//
//       Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
//       print("작성 성공");
//
//       // 댓글 작성 후 텍스트 필드를 초기화합니다.
//       _replyController.clear();
//     } catch (e) {
//       print(e.toString());
//       print("작성 실패");
//     } finally {
//       setState(() {
//         _reply = _replyController.text;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextField(
//               controller: _replyController,
//               decoration: InputDecoration(
//                 labelText: "후기",
//                 border: OutlineInputBorder(),
//               ),
//               style: TextStyle(fontSize: 40),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _replyinsert();
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => ItemDetailPage(id: widget.id, initialTabIndex: 0),
//                   ),
//                 );
//               },
//               child: Text("확인"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
