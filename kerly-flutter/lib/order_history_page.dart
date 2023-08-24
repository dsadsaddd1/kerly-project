import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kerly/changenotifier.dart';
import 'package:provider/provider.dart';
import 'order_historty_detail_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  bool isLoading = false;
  int pageNum = 0;
  List<dynamic> _list = [];
  final ScrollController _scrollController = ScrollController();

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

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String url =
          'http://10.0.2.2:9007/neworder2-service/newOrderList?username=${Provider.of<MemberModel>(context, listen: false).username}&pageNum=${pageNum}';
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> result = data['result'];

      setState(() {
        _list.addAll(result);
        pageNum++;
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

  String generateProductInfo(List<dynamic> orderItems) {
    if (orderItems.length == 1) {
      return orderItems[0]['itemName'];
    } else {
      return '${orderItems[0]['itemName']} 외 ${orderItems.length - 1}종';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문 내역'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: true,
      ),
      body: _list.isEmpty
          ? Center(
        child: Text('주문 내역이 없습니다.'),
      )
          : ListView.separated(
        controller: _scrollController,
        itemCount: _list.length,
        separatorBuilder: (context, index) => Divider(color: Colors.black),
        itemBuilder: (context, index) {
          final order = _list[index];
          final orderItems = order['orderItems'] as List<dynamic>;
          final productInfo = generateProductInfo(orderItems);

          return ListTile(
            title: Text('주문 번호: ${order['orderNum']}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderHistoryDetailPage(id: order['id']),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('상품 총 가격: ${order['totalPrice']}'),
                Text('주문자 이름: ${order['username']}'),
                Text('상품 정보: $productInfo'),
              ],
            ),
          );
        },
      ),
    );
  }
}
