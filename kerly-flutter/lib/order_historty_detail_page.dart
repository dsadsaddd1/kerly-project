import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'item_detail_page.dart';

class OrderHistoryDetailPage extends StatefulWidget {
  final int id;
  const OrderHistoryDetailPage({Key? key, required this.id}):super(key:key);

  @override
  _OrderHistoryDetailPageState createState() => _OrderHistoryDetailPageState();
}

class _OrderHistoryDetailPageState extends State<OrderHistoryDetailPage> {
  bool isLoading = false;
  List<dynamic> _list = [];
  int pageNum = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String url = 'http://10.0.2.2:9007/neworder2-service/newOrderList/id?id=${widget.id}&pageNum=$pageNum';
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      _list = data['result'][0]['orderItems'];
      pageNum++;
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문 상세 내역'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.separated(
        controller: _scrollController,
        itemCount: _list.length,
        separatorBuilder: (context, index) => Divider(color: Colors.black),
        itemBuilder: (context, index) {
          Map<String, dynamic> orderItem = _list[index];
          String itemName = orderItem['itemName'];
          String itemSellerName = orderItem['itemSellerName'];
          int itemPrice = orderItem['itemPrice'];
          int itemStock = orderItem['itemStock'];
          int itemId = orderItem['itemId'];

          return ListTile(
            title: Text(itemName),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailPage(id: itemId, initialTabIndex: 0),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('판매자: $itemSellerName'),
                Text('가격: $itemPrice'),
                Text('개수: $itemStock'),
              ],
            ),
          );
        },
      ),
    );
  }
}
