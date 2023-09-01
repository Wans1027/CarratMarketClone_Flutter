import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../staticModel/url_info.dart';
import '../data/trade_data.dart';

class DetailGoodsScreen extends StatefulWidget {
  const DetailGoodsScreen({
    super.key,
    required this.goods,
  });
  final GoodsDataParse goods;
  //widget.goods 로 사용

  @override
  State<DetailGoodsScreen> createState() => _DetailGoodsScreenState();
}

class _DetailGoodsScreenState extends State<DetailGoodsScreen> {
  late List<String> imageUrls = [];

  Future<void> _fetchImages() async {
    final url = Uri.parse(
        '${UrlList.tradeServiceUrl}/images/${widget.goods.id.toString()}'); // Replace with your server URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        imageUrls = List<String>.from(jsonData['content']);
      });
    } else {
      print('Failed to fetch images');
    }
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        // You can perform any custom logic or navigation
        // If you want to prevent going back, return false
        // If you want to allow going back, return true
        return true; //false는 동작안함
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('상품정보'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await _fetchImages();
              //   },
              //   child: const Text('Fetch Images'),
              // ),
              const SizedBox(height: 16.0),
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black)),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '판매자 이름: ${widget.goods.sellerId.toString()}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '판매지역: ${widget.goods.sellingAreaId.toString()}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black)),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상품제목: ${widget.goods.title}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '생성시간: ${widget.goods.createAt}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        '설명: ${utf8.decode(base64.decode(widget.goods.description))}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
