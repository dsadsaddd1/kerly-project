import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ChangeNotifier: mixin으로 데이터가 변경된 것을 다른 곳에 알려 주기 위해 사용했음.
// 실제로는 notifyListeners( )가 그 역할을 하는데, 그 함수를 ChangeNotifier가 갖고 있어서 구현했음.

class AddressTouch {
  final String address;
  final String detailInfo;

  AddressTouch({
    required this.address,
    required this.detailInfo,
  });
}

class Product {
  String? itemName;
  String? sellerName;
  int? itemPrice;
  int? itemId;
  int? quantity;
  int? itemTotalPrice;

  Product({this.itemName, this.itemPrice, this.sellerName, this.itemId, this. quantity, this.itemTotalPrice});
}

class ShoppingCartModel with ChangeNotifier {

 List<Product> _cartItems = [];
 List<Product> get cartItems => _cartItems;
 int totalAmount = 0;

 void addToCart(Product product) {
   if (_cartItems.any((item) => item.itemId == product.itemId)) {
     // 이미 존재하는 아이템인 경우 처리
     // 예를 들어, 경고 메시지 표시 또는 예외 처리 등
     Fluttertoast.showToast(
       msg: '이미 장바구니에 담겼습니다.',
       toastLength: Toast.LENGTH_SHORT, // 메시지 표시 시간 설정
     );
     return;
   }
   _cartItems.add(product);
   notifyListeners();
 }

 void removeFromCart(Product product) {
   product.quantity = 1;
   _cartItems.remove(product); // 삭제한 상품을 다시 추가할 때 수량을 1로 설정
   calculateTotalAmount(); // 총 가격을 다시 계산해줍니다.
   notifyListeners();
 }

 void clearCart() {
   _cartItems.clear();
   notifyListeners();
 }

 void calculateTotalAmount() {
   int total = 0;
   for (Product product in _cartItems) {
     total += product.itemPrice ?? 0;
   }
   totalAmount = total;
 }

}

class FavoriteModel with ChangeNotifier {

  bool? bookmark;

  FavoriteModel({this.bookmark});

  void changedBookmark(data){
    bookmark = data;
  }

}


class AddressModel with ChangeNotifier {
  String? address;
  String? detailInfo;



  AddressModel({this.address, this.detailInfo, int? selectedAddressIndex});



  void changeAddress(data1, data2) {
    address = data1+" "+data2;
    notifyListeners();
  }

  void changeDetailInfo(data) {
    detailInfo = data;
    notifyListeners();
  }

  Future<void> setAddress(String savedAddress) async {
    address = savedAddress;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', savedAddress);
  }

  Future<void> loadAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAddress = prefs.getString('address');
    if (savedAddress != null) {
      address = savedAddress;
      notifyListeners();
    }
  }

}

class MemberModel with ChangeNotifier {
  String? username;
  String? name;
  String? token;
  int? selectedAddressIndex;
  int? role;

  MemberModel({this.username, this.name, this.token, this.role});

  void setSelectedAddressIndex(int index) {
    selectedAddressIndex = index;
    notifyListeners();
  }


  void allClear() {
    username = "";
    name = "";
    token = "";
    notifyListeners(); // 데이터가 변경됐음을 age를 사용하고 있는 곳에 알려 줌. state가 변경되어 화면이 갱신됨.
  }

  void login(String token, String username, String name, int role) {
    this.username = username;
    this.token = token;
    this.name = name;
    this.role = role;
    notifyListeners();
  }

  void changeName(changeName) {
    name = changeName;
    notifyListeners(); // 데이터가 변경됐음을 age를 사용하고 있는 곳에 알려 줌. state가 변경되어 화면이 갱신됨.
  }
}
