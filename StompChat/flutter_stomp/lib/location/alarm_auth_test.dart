import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Permission Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationPermissionExample(),
    );
  }
}

class NotificationPermissionExample extends StatefulWidget {
  const NotificationPermissionExample({super.key});

  @override
  _NotificationPermissionExampleState createState() =>
      _NotificationPermissionExampleState();
}

class _NotificationPermissionExampleState
    extends State<NotificationPermissionExample> {
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _permissionStatus = status;
    });

    if (!_permissionStatus.isGranted) {
      final result = await Permission.notification.request();
      setState(() {
        _permissionStatus = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Permission Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Notification Permission: $_permissionStatus',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestNotificationPermission,
              child: const Text('알림 권한 허용 요청'),
            ),
          ],
        ),
      ),
    );
  }
}
