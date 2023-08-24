import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'item_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _keywordController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _list = [];
  int pageNum = 0;
  String? keyword;
  final ScrollController _scrollController = ScrollController();
  Map<int, Uint8List> _imageMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadData();
      }
    });

    // 페이지가 처음 로드될 때 검색을 수행합니다.
    loadData(resetPage: true);
  }

  Future<void> loadData({bool resetPage = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      keyword = _keywordController.text;
    });

    if (resetPage) {
      pageNum = 0; // 페이지 번호를 초기화합니다.
      _list.clear(); // 기존 검색 결과를 초기화합니다.
    }

    if (keyword!.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String url =
        'http://10.0.2.2:9007/item-service/search/keyword?keyword=${keyword}&pageNum=${pageNum}';

    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _list.addAll(result);
        pageNum++; // 페이지 번호를 증가시킵니다.
      });
    }

    setState(() {
      _isLoading = false;
    });
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
  void dispose() {
    _scrollController.dispose();
    _keywordController.dispose(); // TextEditingController를 dispose합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),
          TextField(
            controller: _keywordController,
            decoration: InputDecoration(
              hintText: "검색어를 입력하세요",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search, color: Colors.black),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              loadData(resetPage: true);
            },
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: itemListWidget(),
          ),
        ],
      ),
    );
  }

  Widget itemListWidget() {
    return ListView.separated(
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
                builder: (context) =>
                    ItemDetailPage(id: _list[index]["id"], initialTabIndex: 0),
              ),
            );
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
    );
  }
}