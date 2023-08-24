import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kerly/login_page.dart';
import 'package:kerly/order_insert_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'changenotifier.dart';

class BottomBar extends StatefulWidget {
  final int id;

  const BottomBar({Key? key, required this.id}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool? isFavorite;
  bool isLoading = false;
  bool isAddedToCart = false;

  late Product _product; // _product를 late로 선언하여 나중에 값을 할당할 수 있도록 합니다

  @override
  void initState() {
    super.initState();
    loadData();
    loadBookmarkData();
  }

  int _id = 0;
  String _itemName = "";
  String _sellerName = "";
  int _bid = 0;
  int _price = 0;

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
        _id = data['result']['id'];
        _itemName = data['result']['itemName'];
        _sellerName = data['result']['username'];
        _bid = _id;
        _price = data['result']['price'];
        _product = Product(
            itemName: _itemName,
            itemPrice: _price,
            sellerName: _sellerName,
            itemId: _id
        );
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !(isFavorite ?? false); // 기존의 값이 null인 경우 false로 간주하고 토글

      if (isFavorite ?? false) {
        // 즐겨찾기 메서드 동작
        processCreateBookmark();
      } else {
        // 즐겨찾기 취소 메서드 동작
        processDeleteBookmark();
      }
    });
  }

  Future<void> loadBookmarkData() async {
    try {
      String url =
          'http://10.0.2.2:9007/bookmark-service/bid/${widget.id}/username/${Provider.of<MemberModel>(context, listen: false).username}';
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseData = jsonDecode(response.body);
          Provider.of<FavoriteModel>(context, listen: false)
              .changedBookmark(true);
          isFavorite =
              Provider.of<FavoriteModel>(context, listen: false).bookmark;
        });
      } else {
        Provider.of<FavoriteModel>(context, listen: false)
            .changedBookmark(false);
        isFavorite =
            Provider.of<FavoriteModel>(context, listen: false).bookmark;
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> processCreateBookmark() async {
    Map<String, dynamic> body = {
      "bid": _bid.toString(),
      "itemName": _itemName,
      "sellerName": _sellerName,
      "username":
      Provider.of<MemberModel>(context, listen: false).username.toString(),
    };

    try {
      String url = 'http://10.0.2.2:9007/bookmark-service/createBookmark';

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFavorite = true;
          print("즐겨찾기에 추가했습니다.");
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> processDeleteBookmark() async {
    try {
      String url = 'http://10.0.2.2:9007/bookmark-service/deleteBookmark';

      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "bid": _bid,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFavorite = false;
          print("즐겨찾기가 취소되었습니다.");
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void showSnackBar(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  // @override
  // Widget build(BuildContext context) {
  //   var member = Provider.of<MemberModel>(context);
  //   bool isLoggedIn = member.token != "";
  //   return Container(
  //     height: 60,
  //     color: Colors.grey[200],
  //     padding: EdgeInsets.symmetric(horizontal: 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
  //       children: [
  //         IconButton(
  //           icon: Icon(
  //             isFavorite ?? false ? Icons.favorite : Icons.favorite_border,
  //             color: isFavorite ?? false ? Colors.red : Colors.black,
  //           ),
  //           onPressed: isLoggedIn ? toggleFavorite : () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => LoginPage()),
  //             );
  //           },
  //         ),
  //         Expanded(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
  //             children: [
  //               ElevatedButton(
  //                 onPressed: () {
  //                   // 장바구니 추가 버튼 클릭 시 동작
  //                   if (!isAddedToCart) {
  //                     Provider.of<ShoppingCartModel>(context, listen: false)
  //                         .addToCart(_product);
  //                     showSnackBar('장바구니에 담겼습니다.');
  //                     setState(() {
  //                       isAddedToCart = true;
  //                     });
  //                   } else {
  //                     showSnackBar('이미 장바구니에 담겼습니다.');
  //                   }
  //                 },
  //                 style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all<Color>(
  //                       Colors.pinkAccent), // 원하는 색상으로 변경
  //                 ),
  //                 child: Text('장바구니 추가'),
  //               ),
  //               SizedBox(width: 10), // 버튼 사이의 간격 조절을 위해 SizedBox 추가
  //               ElevatedButton(
  //                 onPressed: () {
  //                   // 구매 버튼 클릭 시 동작
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => OrderInsertPage(id: widget.id),
  //                     ),
  //                   );
  //                 },
  //                 style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all<Color>(
  //                       Colors.pink), // 원하는 색상으로 변경
  //                 ),
  //                 child: Text('구매'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var member = Provider.of<MemberModel>(context);
    bool isLoggedIn = member.token != "";
    return Container(
      height: 60,
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
        children: [
          IconButton(
            icon: Icon(
              isFavorite ?? false ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ?? false ? Colors.red : Colors.black,
            ),
            onPressed: isLoggedIn ? toggleFavorite : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
              children: [
                ElevatedButton(
                  onPressed: isLoggedIn ? () {
                    // 장바구니 추가 버튼 클릭 시 동작
                    if (!isAddedToCart) {
                      Provider.of<ShoppingCartModel>(context, listen: false)
                          .addToCart(_product);
                      showSnackBar('장바구니에 담겼습니다.');
                      setState(() {
                        isAddedToCart = true;
                      });
                    } else {
                      showSnackBar('이미 장바구니에 담겼습니다.');
                    }
                  } : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.pinkAccent), // 원하는 색상으로 변경
                  ),
                  child: Text('장바구니 추가'),
                ),
                SizedBox(width: 10), // 버튼 사이의 간격 조절을 위해 SizedBox 추가
                ElevatedButton(
                  onPressed: isLoggedIn ? () {
                    // 구매 버튼 클릭 시 동작
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderInsertPage(id: widget.id),
                      ),
                    );
                  } : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.pink), // 원하는 색상으로 변경
                  ),
                  child: Text('구매'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}