class MainMessageModel {
  final List content;
  final int totalElements;

  MainMessageModel.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        totalElements = json['totalElements'];
}

class ResultModel {
  final List content;
  final int totalElements;

  ResultModel.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        totalElements = json['totalElements'];
}

class MessageDataParse {
  final int roomId, senderId;
  final String type, detailMessage, senderName, sendTime;

  MessageDataParse.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        senderId = json['senderId'],
        type = json['type'],
        detailMessage = json['detailMessage'],
        senderName = json['senderName'],
        sendTime = json['sendTime'];

  MessageDataParse(
      {required this.type,
      required this.roomId,
      required this.senderId,
      required this.detailMessage,
      required this.senderName,
      required this.sendTime});
}
