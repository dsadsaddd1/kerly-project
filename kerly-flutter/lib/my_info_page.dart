import 'package:flutter/material.dart';
import 'package:kerly/changenotifier.dart';
import 'package:kerly/customer_service_page.dart';
import 'package:kerly/delete_service_page.dart';
import 'package:kerly/favorite_products_page.dart';
import 'package:kerly/item_control_page.dart';
import 'package:kerly/logout.dart';
import 'package:kerly/order_history_page.dart';
import 'package:kerly/password_update_page.dart';
import 'package:kerly/personal_info_page.dart';
import 'package:kerly/about_kerly.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class MyInfoPage extends StatefulWidget {
  final String? token;

  MyInfoPage({Key? key, this.token}) : super(key: key);

  bool get isLoggedIn => token != "";

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    var member = Provider.of<MemberModel>(context);
    bool isRole = member.role == 1;
    return Scaffold(
      body: member.token == null || member.token!.isEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 8),
                  child: Text(
                    '내 정보',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      '회원 가입 시\n다양한 이벤트가 있습니다',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.pinkAccent),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 80),
                        ),
                      ),
                      child: Text('로그인/회원가입'),
                    ),
                    SizedBox(height: 40),
                    Container(
                      height: 1.0,
                      width: 350.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text('  켈리 소개'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutKerly()),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('  고객센터'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerServicePage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.pink,
                            size: 30,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${member.name} 님',
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    '내 정보 페이지',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      ListTile(
                        title: Text('개인정보 수정'),
                        onTap: () {
                          User loggedInUser = User(
                            username: '${member.username}',
                            name: '${member.name}',
                            phoneNumber: '${phoneNumber}',
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PersonalInfoPage(
                                    loggedInUser: loggedInUser)),
                          );
                        },
                      ),
                      Container(
                        height: 1.0,
                        width: 500.0,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: Text('주문 내역'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderHistoryPage()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('찜한 상품'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoriteProductsPage()),
                          );
                        },
                      ),
                      if (isRole)
                        ListTile(
                          title: Text('상품 관리'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemControlPage()),
                            );
                          },
                        ),
                      Container(
                        height: 1.0,
                        width: 500.0,
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: Text('켈리 소개'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutKerly()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('고객센터'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerServicePage()),
                          );
                        },
                      ),
                      Container(
                        height: 1.0,
                        width: 500.0,
                        color: Colors.grey,
                      ),
                      if (member.token != null && member.token!.length > 0) ...[
                        ListTile(
                          title: Text('로그아웃'),
                          onTap: () {
                            Logout.logout(context, MyInfoPage());
                          },
                        ),
                        ListTile(
                          title: Text('회원 탈퇴'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteServicePage(
                                      username: member.username!)),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
