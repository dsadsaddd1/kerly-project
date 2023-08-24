import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kerly/changenotifier.dart';
import 'package:kerly/item_detail_page.dart';
import 'package:provider/provider.dart';

class FavoriteProductsPage extends StatefulWidget {
  const FavoriteProductsPage({Key? key}) : super(key: key);

  @override
  State<FavoriteProductsPage> createState() => _FavoriteProductsPageState();
}

class _FavoriteProductsPageState extends State<FavoriteProductsPage> {
  @override
  void initState() {
    super.initState();
    loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  int pageNum = 0;
  List<dynamic> _list = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String url =
          'http://10.0.2.2:9007/bookmark-service/username/?username=${Provider
          .of<MemberModel>(context, listen: false)
          .username}&pageNum=${pageNum}';
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      List<dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        setState(() {
          _list.addAll(result);
        });
        pageNum++;
      });

      setState(() {
        isLoading = false;
      });

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> processDeleteBookmark(index) async {
    try {
      String url = 'http://10.0.2.2:9007/bookmark-service/deleteBookmark';

      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "bid": _list[index]["bid"],
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          print("즐겨찾기가 취소되었습니다.");
          _list.clear();
        });
      }
    } catch (e) {
      print(e);
    } finally{
      pageNum = 0;
      loadData();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('찜한 상품'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: _list.isEmpty
                  ? Text(
                '찜한 상품이 없습니다.',
                style: TextStyle(fontSize: 18),
              )
                  : ListView.separated(
                controller: _scrollController,
                itemCount: _list.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.black),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItemDetailPage(
                                id: _list[index]["bid"],initialTabIndex: 0
                              ),
                        ),
                      );
                    },
                    child: ListTile(
                      key: ValueKey(_list[index]["bid"]),
                      title: Text(_list[index]["itemName"]),
                      subtitle:
                      Text("판매자: " + _list[index]["sellerName"]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          processDeleteBookmark(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            isLoading ? CircularProgressIndicator() : SizedBox(),
          ],
        ),
      ),
    );
  }
}