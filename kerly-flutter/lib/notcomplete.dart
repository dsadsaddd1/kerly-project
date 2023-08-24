import 'package:flutter/material.dart';

class NotComplete extends StatelessWidget {
  const NotComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularProgressIndicator(),
    );
  }
}