import 'package:flutter_stomp/model/messageList_model.dart';
import 'package:flutter_stomp/staticModel/member_info.dart';
import 'package:http/http.dart' as http;
import 'data/trade_data.dart';
import 'dart:convert';

class TradeApi {
  static Future<List<GoodsDataParse>> getGoodsByAreaId(
      List<int> areaIds) async {
    List<GoodsDataParse> postData = [];
    var baseUrl = MemberInfo.baseURL;
    String ltoS = '';
    for (var i = 0; i < areaIds.length; i++) {
      if (i != areaIds.length - 1) {
        ltoS += '${areaIds[i]},';
      } else {
        ltoS += '${areaIds[i]}';
      }
    }
    final url = Uri.parse('$baseUrl/goods?areaIdList=$ltoS');
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('받음');
      final posts = jsonDecode(utf8.decode(response.bodyBytes));
      //final aaa = ResultModel.fromJson(posts).content;
      //totalPage = MainBoardModel.fromJson(posts).totalElements;
      for (var element in ResultModel.fromJson(posts).content) {
        print(element);
        print(GoodsDataParse.fromJson(element).sellPrice);
        postData.add(GoodsDataParse.fromJson(element));
      }
      return postData;
    } else {
      print('실행안됨');
    }
    throw Exception('exceptioon!');
  }
}
