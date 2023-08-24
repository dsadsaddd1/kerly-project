import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kerly/item_detail_page.dart';

class ItemBoardPage extends StatefulWidget {
  final String itemType;

  ItemBoardPage(this.itemType, {super.key});

  @override
  _ItemBoardPageState createState() => _ItemBoardPageState();
}

class _ItemBoardPageState extends State<ItemBoardPage> {
  int pageNum = 0;
  List<dynamic> _list = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Map<int, Uint8List> _imageMap = {};

  Future<void> loadData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    String url =
        'http://10.0.2.2:9007/item-service/itemtype/itemtype?itemType=${widget.itemType}&pageNum=${pageNum}';

    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        _list.addAll(result);
      });
      pageNum++;
    }

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
  }

  Future<void> loadImageData(int bid) async {
    if (!_imageMap.containsKey(bid)) {
      try {
        var response = await http.get(Uri.parse(
            'http://10.0.2.2:9007/file-service/fileDownload/$bid'));
        if (response.statusCode == 200) {
          setState(() {
            _imageMap[bid] = response.bodyBytes;
          });
        } else {
          // Handle error case
        }
      } catch (e) {
        // Handle error case
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    // var member = Provider.of<MemberModel>(context);
    // bool isRole = member.role == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.itemType}"),
        backgroundColor: Colors.pinkAccent,

      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: _list.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                height: 1,
              ),
              itemBuilder: (context, index) {
                int bid = _list[index]['id'];
                if (!_imageMap.containsKey(bid)) {
                  loadImageData(bid);
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailPage(id: _list[index]["id"], initialTabIndex: 0),
                      ),
                    ).then((value) {
                      if (value != null && value is bool && value) {
                        loadData(); // A 페이지로부터 돌아왔을 때 데이터 로드
                      }
                    });
                  },
                  child: ListTile(
                    key: ValueKey(_list[index]["id"]),
                    title: Text(_list[index]["itemName"]),
                    subtitle: Text(_list[index]["itemDescribe"]),
                    trailing: Text(_list[index]["itemType"]),
                    leading: _imageMap.containsKey(bid)
                        ? Image.memory(
                      _imageMap[bid]!,
                      width: 50,
                      height: 50,
                    )
                        : Image.asset(
                      'assets/test1.gif',
                      width: 50,
                      height: 50,
                    ),
                  ),
                );
              },
            ),
          ),
          isLoading ? CircularProgressIndicator() : SizedBox(),
        ],
      ),
    );
  }
}

