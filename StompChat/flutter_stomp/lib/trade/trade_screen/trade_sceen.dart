import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stomp/staticModel/member_info.dart';
import 'package:flutter_stomp/trade/data/trade_data.dart';
import 'package:flutter_stomp/trade/trade_api.dart';
import 'package:flutter_stomp/trade/trade_screen/trade_detail_screen.dart';
import 'package:flutter_stomp/trade/trade_screen/trade_selling_screen.dart';
import 'package:flutter_stomp/trade/widget/trade_widget.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  late Future<List<GoodsDataParse>> goodsList;
  var decoded = base64.decode('QSBnb29kIGRheSBpcyBhIGRheSB3aXRob3V0IHNub3c=');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goodsList = TradeApi.getGoodsByAreaId(MemberInfo.memberAreaList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SellingPage()),
          );
        },
        label: const Text('글쓰기'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: goodsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    for (var goods in snapshot.data!)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailGoodsScreen(goods: goods)),
                          ).then((value) => setState(() {}));
                        },
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: GoodsWidget(goods: goods)),
                      )
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(), //로딩중 동그라미 그림
              );
            }),
      ),
    );
  }
}
