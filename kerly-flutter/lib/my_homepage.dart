import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kerly/address_page.dart';
import 'package:kerly/categories_page.dart';
import 'package:kerly/changenotifier.dart';
import 'package:kerly/item_board_page.dart';
import 'package:kerly/login_page.dart';
import 'package:kerly/search_page.dart';
import 'package:kerly/shopping_cart_page.dart';
import 'package:kerly/slide_image_page.dart';
import 'package:kerly/sql/address.dart';
import 'package:kerly/sql/address_crud.dart';
import 'package:provider/provider.dart';
import 'my_info_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  final int initialTabIndex;

  const MyHomePage({Key? key, int? id, required this.initialTabIndex})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool isLoadLoginData = false;

  final CarouselController controller = CarouselController();

  late SharedPreferences _prefs;
  int? selectedAddressIndex;

  List<dynamic> imageUrls = [];
  String? imageUrl;
  bool _isLoading = false;

  int pageNum = 0;
  List<dynamic> _list = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<int> loadSelectedAddressIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedAddressIndex = prefs.getInt("selectedAddressIndex");
    return selectedAddressIndex ?? -1; // 기본값을 설정해주는 것이 좋습니다.
  }

  Future<void> _saveSelectedAddressIndex(
      int index, String address, String detailInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedAddressIndex', index);
    await prefs.setString('selectedAddress', address);
    await prefs.setString('selectedDetailInfo', detailInfo);

    setState(() {
      selectedAddressIndex = index;
    });
  }

  late TabController _tabController;
  int _selectedIndex = 0;

  void selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabController!.animateTo(index);
  }

  @override
  void initState() {
    super.initState();
    loadImageData();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        selectedAddressIndex = _prefs.getInt('selectedAddressIndex');
      });
      loadSelectedAddressIndex().then((index) {
        setState(() {
          selectedAddressIndex = index;
          String address = prefs.getString('selectedAddress') ?? '';
          String detailInfo = prefs.getString('selectedDetailInfo') ?? '';
          Provider.of<AddressModel>(context, listen: false)
              .changeAddress(address, detailInfo);
        });
      });
    });

    _tabController = TabController(
        length: 4, vsync: this, initialIndex: widget.initialTabIndex ?? 0);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<dynamic> imageList = [];

  List<String> kerlyList = [
    "https://i.pinimg.com/564x/cf/55/23/cf5523c9b82901ecd95b864cf6f9ccb1.jpg",
    "https://i.pinimg.com/564x/b7/c6/80/b7c680b4d33db505f505ab053830fa31.jpg",
    "https://i.pinimg.com/564x/9e/67/2b/9e672b22f633f9daf9b85c9d75085fb7.jpg",
    "https://i.pinimg.com/564x/38/36/e6/3836e6eca3f657329ef24a7cdf31e529.jpg",
    "https://i.pinimg.com/564x/b9/89/a5/b989a52739551d3827209cdbe27d8993.jpg",
    "https://i.pinimg.com/564x/3d/3b/84/3d3b842e0a6c8b44e546e686815b647d.jpg",
    "https://i.pinimg.com/564x/c1/30/34/c13034250259fd913fe5e4803aba26b1.jpg",
    "https://i.pinimg.com/564x/c7/1a/82/c71a826445eca6a0fa394bb84fba3bea.jpg",
    "https://i.pinimg.com/564x/d3/7e/d8/d37ed813a1b774391c6a99cbe9eb3f41.jpg",
  ];

  Widget tabContainer(BuildContext context, Color tabcolor, String tabText) {
    return Container(
      color: tabcolor,
      child: Center(
        child: Text(
          tabText,
        ),
      ),
    );
  }

  Widget tabContainer1(BuildContext context) {
    return Column(
      children: [
        sliderWidget(),
        SizedBox(height: 30),
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            // 배열 이미지 간의 세로 간격
            crossAxisSpacing: 10,
            // 배열 이미지 간의 가로 간격
            childAspectRatio: 1,
            // 이미지의 가로:세로 비율 조정
            children: List.generate(kerlyList.length, (index) {
              return InkWell(
                onTap: () {
                  String category = ""; // 해당 이미지에 맞는 카테고리 설정
                  if (index == 0) {
                    category = "과일·채소";
                  } else if (index == 1) {
                    category = "정육·계란";
                  } else if (index == 2) {
                    category = "수산·해산";
                  } else if (index == 3) {
                    category = "샐러드·간편식";
                  } else if (index == 4) {
                    category = "면·양념";
                  } else if (index == 5) {
                    category = "생수·음료";
                  } else if (index == 6) {
                    category = "우유·치즈";
                  } else if (index == 7) {
                    category = "간식·과자";
                  } else if (index == 8) {
                    category = "베이커리·떡";
                  }
                  // TODO: 해당 카테고리에 맞는 세부 페이지로 이동하는 코드 작성
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemBoardPage(category),
                    ),
                  );
                },
                child: Image.network(
                  kerlyList[index],
                  fit: BoxFit.cover,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget tabContainer2(BuildContext context) {
    return CategoriesPage();
  }

  Widget tabContainer3(BuildContext context) {
    return SearchPage();
  }

  Widget tabContainer4(BuildContext context) {
    return MyInfoPage();
  }

  @override
  Widget build(BuildContext context) {
    var member = Provider.of<MemberModel>(context);
    bool isLoggedIn = member.token != "";
    bool isRole = member.role == 1;

    int _selectedIndex = _tabController.index; // 현재 선택된 탭의 인덱스를 저장

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            setState(() {
              _tabController.index = 0; // 첫 번째 탭 선택
            });
          },
          child: Image.asset(
            'assets/로고.png',
            width: 30,
            height: 30,
          ),
        ),
        automaticallyImplyLeading: false,
        title: _selectedIndex == 2 ? Center(child: Text("검색")) : null,
        backgroundColor: Colors.pinkAccent,
        actions: [
          if (isRole && _selectedIndex == 0)
            IconButton(
              onPressed: () {
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SlideImageAdd()),
                  );
                }
              },
              icon: Icon(Icons.image),
            ),
          IconButton(
            onPressed: () async {
              if (isLoggedIn) {
                await showPopupPage(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                return null;
              }
            },
            icon: Icon(Icons.location_on),
          ),
          IconButton(
            onPressed: () {
              if (isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingCartPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                tabContainer1(context),
                tabContainer2(context),
                tabContainer3(context),
                tabContainer4(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ColoredBox(
          color: Colors.pinkAccent,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            tabs: [
              Tab(
                icon: _selectedIndex == 0
                    ? Icon(Icons.home)
                    : Icon(Icons.home_outlined), // 선택된 탭과 선택되지 않은 탭에 다른 아이콘 적용
                text: _selectedIndex == 0 ? "홈" : null,
              ),
              Tab(
                icon: _selectedIndex == 1
                    ? Icon(Icons.menu)
                    : Icon(Icons.menu_outlined),
                text: _selectedIndex == 1 ? "카테고리" : null,
              ),
              Tab(
                icon: _selectedIndex == 2
                    ? Icon(Icons.search)
                    : Icon(Icons.search_outlined),
                text: _selectedIndex == 2 ? "검색" : null,
              ),
              Tab(
                icon: _selectedIndex == 3
                    ? Icon(Icons.person)
                    : Icon(Icons.person_outline),
                text: _selectedIndex == 3 ? "내정보" : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Address>> loadingAddressList() async {
    List<Address> addressList = await SqlAddressCrudRepository.getList();
    return List.from(addressList.reversed);
  }

  Future<int> deleteById(int id) async {
    print(selectedAddressIndex.toString() + "????????????????");
    print(id);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (selectedAddressIndex != id) {
      await _saveSelectedAddressIndex(-1, "", "");
      await prefs.setString('address', "");
      await prefs.setString('detailInfo', "");

      Provider.of<AddressModel>(context, listen: false).address = "";
      Provider.of<AddressModel>(context, listen: false).detailInfo = "";
    }

    return await SqlAddressCrudRepository.deleteById(id);
  }

  Future<void> showPopupPage(BuildContext context) async {
    var member = Provider.of<MemberModel>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? selectedAddressIndex = await loadSelectedAddressIndex();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4, // 화면 높이의 절반
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: FutureBuilder<List<Address>>(
          future: loadingAddressList(),
          builder: (context, AsyncSnapshot<List<Address>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("sqflite를 사용할 수 없습니다."),
              );
            } else {
              if (snapshot.hasData) {
                var addressList = snapshot.data;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '배송지 설정',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(height: 1.0), // 간격 조정
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_sharp),
                          SizedBox(width: 3.0), // 아이콘과 텍스트 사이 간격
                          Text('배송지 추가'),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0), // 간격 조정
                    Expanded(
                      child: ListView.builder(
                        itemCount: addressList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          String postCode = addressList![index].postCode;
                          String address = addressList![index].address;
                          String detailInfo = addressList![index].detailInfo;

                          return Dismissible(
                            key: ValueKey(addressList![index].id.toString()),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) async {
                              setState(() {
                                if (direction == DismissDirection.startToEnd) {
                                  deleteById(addressList![index].id!);
                                }
                              });
                            },
                            background: Container(
                              color: Colors.white,
                              child: Icon(
                                Icons.delete,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                AddressTouch newAddress = AddressTouch(
                                  address: '$address',
                                  detailInfo: '$detailInfo',
                                );
                                member.setSelectedAddressIndex(
                                    index); // 선택된 주소 인덱스 설정
                                await _saveSelectedAddressIndex(index, address,
                                    detailInfo); // Save the selected address index
                                await loadSelectedAddressIndex();
                                Provider.of<AddressModel>(context,
                                        listen: false)
                                    .changeAddress(address, detailInfo);
                                Navigator.pop(context);
                                print('주소를 터치했습니다');
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      '우편번호: $postCode',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '주소: $address',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        Text(
                                          '상세 주소: $detailInfo',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    selected: selectedAddressIndex == index,
                                    trailing: selectedAddressIndex == index
                                        ? Icon(Icons.check)
                                        : null,
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 1.0,
                                    width: 500.0,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget sliderIndicator() {
    return Container();
  }

  Future<void> loadImageData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String url = 'http://10.0.2.2:9007/file-service/all';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> result = data['result'];

        List<String> imageUrls =
            result.map((item) => item['imageUrl']).cast<String>().toList();

        setState(() {
          // imageUrls = List<dynamic>.from(result);
          imageList = imageUrls;
        });
      } else {
        // Handle error case
      }
    } catch (e) {
      // Handle error case
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget sliderWidget() {
    return SizedBox(
      height: 200, // 이미지 슬라이더의 높이를 고정
      child: CarouselSlider(
        carouselController: controller,
        items: imageList.map(
          (imageUrl) {
            return Builder(
              builder: (context) {
                return Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                );
              },
            );
          },
        ).toList(),
        options: CarouselOptions(
          height: 200,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 10),
        ),
      ),
    );
  }
}
