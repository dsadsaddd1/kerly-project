import 'package:flutter/material.dart';

class CustomerServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('고객센터'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: true,
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '고객센터 안내',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '문의 전화번호: 123-456-7890',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                '이메일: kerly@example.com',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                '운영 시간: 월-금 9:00 AM - 6:00 PM',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}