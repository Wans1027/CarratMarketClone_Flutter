import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stomp/model/messageList_model.dart';
import 'package:flutter_stomp/service/api_service.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

// 채팅 목록을 저장할 리스트
List<MessageDataParse> messages = [];
int chatRoomId = 1;
int myId = 2;

class StompScreen extends StatefulWidget {
  const StompScreen({super.key});

  @override
  State<StompScreen> createState() => _StompScreenState();
}

class _StompScreenState extends State<StompScreen> {
  late StompClient stompClient;
  ScrollController scrollController = ScrollController();
  void onConnect(StompClient stompClient, StompFrame frame) {
    stompClient.subscribe(
      destination: '/topic/1',
      callback: (frame) {
        //List<dynamic>? result = json.decode(frame.body!);
        Map<String, dynamic> obj = json.decode(frame.body!);
        MessageDataParse message = MessageDataParse(
            detailMessage: obj['detailMessage'],
            roomId: obj['roomId'],
            senderId: obj['senderId'],
            senderName: obj['senderName'],
            type: obj['type'],
            sendTime: obj['sendTime']);
        setState(() => {
              messages.add(message),
              // Future.delayed(const Duration(milliseconds: 30), () {
              //   scrollController
              //       .jumpTo(scrollController.position.maxScrollExtent);
              // })
            });

        print('성공');
      },
    );
  }

  late Future<List<MessageDataParse>> storedMessages;
  @override
  void initState() {
    super.initState();

    try {
      storedMessages = ApiService.getAllMessages(1);
      storedMessages.then((value) {
        messages = value;
        setState(() {});

        stompClient = StompClient(
          config: StompConfig(
              url: 'ws://175.195.107.156:8080/ws/chat',
              onConnect: (frame) => onConnect(stompClient, frame),
              beforeConnect: () async {
                print('waiting to connect...');
                await Future.delayed(const Duration(milliseconds: 200));
                print('connecting...');
              },
              onWebSocketError: (dynamic error) => print(error.toString())
              //stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
              //webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
              ),
        );

        stompClient.activate();
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  void dispose() {
    super.dispose();
    // 웹소켓에서 연결 해제
    stompClient.deactivate();
    // 텍스트 입력 컨트롤러 해제
    textController.dispose();
  }

  // 텍스트 입력 컨트롤러
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STOMP채팅'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // return ListTile(
                //   title: Text(messages[index].detailMessage),
                //);
                return chat(
                    messages[index].detailMessage,
                    (index != 0 &&
                            messages[index].senderName ==
                                messages[index - 1].senderName &&
                            messages[index].sendTime.substring(0, 16) ==
                                messages[index - 1].sendTime.substring(0, 16))
                        ? ''
                        : messages[index].senderName,
                    messages[index].senderId == myId,
                    messages[index].sendTime);
              },
            ),
          ),
          // 텍스트 입력 필드와 전송 버튼을 가진 Row
          Row(
            children: [
              // 텍스트 입력 필드
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your message',
                  ),
                ),
              ),
              // 전송 버튼
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // 텍스트 입력 필드의 내용을 가져옴
                  String message = textController.text;
                  if (message.isNotEmpty) {
                    // destination에 메시지 전송
                    stompClient.send(
                      destination: '/app/message', // 전송할 destination
                      body: json.encode({
                        "type": "TALK",
                        "roomId": 1,
                        "senderId": myId,
                        "detailMessage": message,
                        "senderName": "Park"
                      }), // 메시지의 내용
                    );
                    // 텍스트 입력 필드를 비움
                    textController.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row chat(String text, String userName, bool isMine, String sendTime) {
    return Row(
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            (userName == '')
                ? Text(
                    userName,
                    style: const TextStyle(fontSize: 1),
                  )
                : Text(
                    userName,
                    style: const TextStyle(fontSize: 15),
                  ),
            isMine
                ? Row(
                    children: [
                      Text(
                        sendTime.substring(11, 16),
                        style: const TextStyle(fontSize: 10),
                      ),
                      Container(
                        margin: const EdgeInsets.all(3),
                        padding: const EdgeInsets.all(9),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.amber),
                        child: Text(text),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(3),
                        padding: const EdgeInsets.all(9),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Color.fromARGB(255, 224, 186, 73)),
                        child: Text(text),
                      ),
                      Text(
                        sendTime.substring(11, 16),
                        style: const TextStyle(fontSize: 10),
                      )
                    ],
                  )
          ],
        )
      ],
    );
  }
}

class Msg {
  String type;
  int roomId;
  int senderId;
  String detailMessage;
  String senderName;
  String sendTime;

  Msg(
      {required this.type,
      required this.roomId,
      required this.senderId,
      required this.detailMessage,
      required this.senderName,
      required this.sendTime});
}
