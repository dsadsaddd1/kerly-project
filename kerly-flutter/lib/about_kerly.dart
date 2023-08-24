import 'package:flutter/material.dart';

class AboutKerly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('켈리 소개'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Image.network(
              'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA2MjhfMTU5%2FMDAxNTYxNzMzMjA4MjIx.y6p6MlZmKqcnEVRjLcRseMVOXrQVF-Wt_UcugmGW46Yg.AVFwNgUK0gbAUoYmBWBa64WnhDdonlRT0uRIyCOVm7wg.JPEG.shineeesmile%2F%25BE%25DF%25C3%25A4%25C8%25BF%25B4%25C96.jpg',
              alignment: Alignment.topCenter,
            ),
          SizedBox(height: 40),
          Text(
            '  켈리의 소개',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 1.0,
            width: 400.0,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '1. 켈리는 친환경, 무농약의 안전하고 건강한 제품만 판매합니다.\n\n2.같은 품질에서 최선의 가격을 제공합니다.\n\n3.고객의 행복을 먼저 생각합니다.\n\n4.지속 가능한 유통을 실현해 나갑니다.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
