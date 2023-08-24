import 'package:flutter/material.dart';

class ProductReviewsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 후기'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Text(
          '상품 후기 페이지',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
