import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'changenotifier.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  int totalAmount = 0; // 총 가격을 나타내는 변수

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      calculateTotalAmount(); // 페이지가 로드되면 총 가격 계산
    });
  }

  void calculateTotalAmount() {
    // 총 가격 계산
    int total = 0;
    for (Product product
        in Provider.of<ShoppingCartModel>(context, listen: false).cartItems) {
      total += (product.itemPrice ?? 0) * (product.quantity ?? 1);
    }
    setState(() {
      totalAmount = total;
      print(total);
    });
  }

  void removeFromCart(Product product) {
    // 상품 삭제
    Provider.of<ShoppingCartModel>(context, listen: false)
        .removeFromCart(product);
    calculateTotalAmount();
  }

  Future<void> insertNewOrder() async {
    List<Map<String, dynamic>> orderItems =
        Provider.of<ShoppingCartModel>(context, listen: false)
            .cartItems
            .map((product) => {
                  "itemName": product.itemName,
                  "itemPrice": product.itemPrice ?? 0,
                  "itemId": product.itemId,
                  "itemStock": product.quantity ?? 1,
                  "itemSellerName": product.sellerName,
                  "itemTotalPrice":
                      (product.itemPrice ?? 0) * (product.quantity ?? 1),
                })
            .toList();

    Map<String, dynamic> body = {
      "orderItems": orderItems,
      "username": Provider.of<MemberModel>(context, listen: false).username,
      "totalPrice": totalAmount
    };

    try {
      String url = 'http://10.0.2.2:9007/neworder2-service/createNewOrder';
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception();
      }
      Provider.of<ShoppingCartModel>(context, listen: false)
          .cartItems
          .forEach((product) => product.quantity = 1);
      Provider.of<ShoppingCartModel>(context, listen: false).clearCart();
      calculateTotalAmount();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("알림"),
          content: Text("구매가 완료되었습니다."),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                // 이전 페이지로 돌아가기

                 Navigator.of(context).pop();
                 Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: true,
      ),
      body: Consumer<ShoppingCartModel>(
        builder: (context, cartModel, child) {
          if (cartModel.cartItems.isEmpty) {
            return Center(
              child: Text('장바구니가 비어있습니다.'),
            );
          } else {
            return Column(
              children: [
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.separated(
                    itemCount: cartModel.cartItems.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.black),
                    itemBuilder: (context, index) {
                      Product product = cartModel.cartItems[index];
                      int quantity = product.quantity ?? 1;

                      String itemName = product.itemName ?? '';
                      String sellerName = product.sellerName ?? '';
                      String itemPrice = (product.itemPrice ?? 0).toString();

                      if (itemName.length > 8) {
                        itemName = itemName.substring(0, 8) + '...';
                      }
                      if (sellerName.length > 8) {
                        sellerName = sellerName.substring(0, 8) + '...';
                      }
                      if (itemPrice.length > 8) {
                        itemPrice = itemPrice.substring(0, 8) + '...';
                      }

                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(height: 10,),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(height: 2,),
                                  Text(
                                    '판매자: $sellerName',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '가격: $itemPrice원',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        product.quantity = quantity - 1;
                                        calculateTotalAmount();
                                      });
                                    }
                                  },
                                ),
                                Text(
                                  '$quantity',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      product.quantity = quantity + 1;
                                      calculateTotalAmount();
                                    });
                                  },
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                removeFromCart(product);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        '총 가격: $totalAmount원',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          insertNewOrder();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.pinkAccent), // 원하는 색상으로 변경
                        ),
                        child: Text('구매하기'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

