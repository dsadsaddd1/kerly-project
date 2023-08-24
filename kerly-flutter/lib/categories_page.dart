import 'package:flutter/material.dart';
import 'package:kerly/item_board_page.dart';

class CategoriesPage extends StatelessWidget {
  final List<String> categories = [
    '과일·채소',
    '정육·계란',
    '수산·해산',
    '샐러드·간편식',
    '면·양념',
    '생수·음료',
    '우유·치즈',
    '간식·과자',
    '베이커리·떡',
  ];

  final List<IconData> icons = [
    Icons.shopping_basket,
    Icons.local_offer,
    Icons.local_dining,
    Icons.fastfood,
    Icons.restaurant_menu,
    Icons.local_cafe,
    Icons.local_drink,
    Icons.emoji_food_beverage,
    Icons.cake,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Text(
              '카테고리',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(icons[index]),
                  title: Text(categories[index]),
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemBoardPage("과일·채소")),
                      );
                    } else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemBoardPage("정육·계란")),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemBoardPage("수산·해산")),
                      );
                    } else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemBoardPage("샐러드·간편식")),
                      );
                    } else if (index == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemBoardPage("면·양념")),
                      );
                    } else if (index == 5) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemBoardPage("생수·음료")),
                      );
                    } else if (index == 6) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemBoardPage("우유·치즈")),
                      );
                    } else if (index == 7) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemBoardPage("간식·과자")),
                      );
                    } else if (index == 8) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemBoardPage("베이커리·떡")),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }



// @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // appBar: AppBar(
  //     //   title: Text('카테고리'),
  //     //   backgroundColor: Colors.pinkAccent,
  //     //   automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
  //     // ),
  //     body: ListView.builder(
  //       itemCount: categories.length,
  //       itemBuilder: (context, index) {
  //         return ListTile(
  //           leading: Icon(icons[index]),
  //           title: Text(categories[index]),
  //           onTap: () {
  //             if (index == 0) {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ItemBoardPage("과일·채소")));
  //             } else if (index == 1) {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ItemBoardPage("정육·계란")));
  //             } else if (index == 2) {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ItemBoardPage("수산·해산")));
  //
  //             } else if (index == 3) {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ItemBoardPage("샐러드·간편식")));
  //             } else if (index == 4) {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ItemBoardPage("면·양념")));
  //             } else if (index == 5) {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ItemBoardPage("생수·음료")));
  //             } else if (index == 6) {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ItemBoardPage("우유·치즈")));
  //             } else if (index == 7){
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ItemBoardPage("간식·과자")));
  //             } else if(index == 8){
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ItemBoardPage("베이커리·떡")));
  //             }
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
}
