import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stomp/location/location_test.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //여기서 //message.data['dataKey'] 로 라우팅합시다.
  // var data = message.data['key'];
  // switch (data) {
  //   case 'chat':
  //     MaterialPageRoute(builder: (context) => const TradeScreen());
  //     break;
  //   case 'trade':
  //     MaterialPageRoute(builder: (context) => const TradeScreen());
  //     break;
  //   default:
  // }

  print("핸들링 백그라운드메시지 message: ${message.data} ");
  print("핸들링 백그라운드메시지 message: ${message.notification!.title} ");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bindingAndGetToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page Transition Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: StompScreen(),
      //home: const TradeScreen(),
      home: const LocationScreen(),
    );
  }
}

Future<void> bindingAndGetToken() async {
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('토큰: $fcmToken');
  FirebaseMessaging.instance.onTokenRefresh.listen((newFcmToken) {
    // TODO: If necessary send token to application server.
    print('새로운토큰: $newFcmToken');
  }).onError((err) {
    // Error getting token.
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}
