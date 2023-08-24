import 'package:flutter/material.dart';
import 'package:kerly/my_homepage.dart';
import 'package:kerly/sql/address.dart';
import 'package:kerly/sql/address_crud.dart';
import 'package:kpostal/kpostal.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool test = false;
  String postCode = '-';
  String address = '-';
  String detailInfo = '';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  TextEditingController _dataController = TextEditingController(); // 상세 주소

  Future<void> _saveData() async {
    String detailInfo = " "+_dataController.text;
    SqlAddressCrudRepository.create(
        Address(postCode: postCode, address: address, detailInfo: detailInfo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("주소"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KpostalView(
                      useLocalServer: true,
                      callback: (Kpostal result) {
                        postCode = result.postCode;
                        address = result.address;
                        latitude = result.latitude.toString();
                        longitude = result.longitude.toString();
                      },
                    ),
                  ),
                );

                setState(() {});
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),
              ),
              child: Text(
                '주소검색',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(40.0),
              child: test
                  ? CircularProgressIndicator()
                  : Column(
                children: [
                  Text(
                    '우편번호 : ${this.postCode.replaceAll('-', '')}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '주소 : ${this.address.replaceAll('-', '')}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '상세 주소',
                    style:
                    TextStyle(fontSize: 15, color: Colors.blueGrey),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: 200, // 원하는 너비로 설정하세요.
                    height: 40,
                    child: TextField(
                      controller: _dataController,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: OutlineInputBorder(), // 네모난 테두리 적용
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {
                      _saveData();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(initialTabIndex: 0,)),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.pinkAccent), // 버튼 색상을 amber로 설정
                    ),
                    child: Text("입력 완료"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
