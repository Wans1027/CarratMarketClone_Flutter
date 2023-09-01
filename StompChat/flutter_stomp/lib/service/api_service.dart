import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/messageList_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  //10.0.2.2
  static Future<List<MessageDataParse>> getAllMessages(int roomId) async {
    List<MessageDataParse> postData = [];
    final url = Uri.parse('$baseUrl/list/$roomId');
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('받음');
      final posts = jsonDecode(utf8.decode(response.bodyBytes));
      final aaa = MainMessageModel.fromJson(posts).content;
      //totalPage = MainBoardModel.fromJson(posts).totalElements;
      for (var element in aaa) {
        postData.add(MessageDataParse.fromJson(element));
      }
      return postData;
    } else {
      print('실행안됨');
    }
    throw Exception('exceptioon!');
  }
}
