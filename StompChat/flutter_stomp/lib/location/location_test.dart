import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}
//안드로이드
//android/app/src/main/AndroidManifest.xml 설정필요
//<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

//IOs
//ios/Runner/Info.plist
/*
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>앱에서 위치 정보를 사용하려 합니다.</string>
 */
class _LocationScreenState extends State<LocationScreen> {
  String locationMessage = "";
  bool locationServiceEnabled = false;
  late LocationPermission locationPermission;

  @override
  void initState() {
    super.initState();
    checkLocationService();
  }

  Future<void> checkLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationMessage = "위치 서비스를 활성화해주세요.";
      setState(() {});
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      locationMessage = "위치 권한이 영구적으로 거부되었습니다.";
      setState(() {});
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationMessage = "위치 권한이 거부되었습니다.";
        setState(() {});
        return;
      }
    }

    locationPermission = permission;
    locationServiceEnabled = serviceEnabled;

    if (locationPermission == LocationPermission.whileInUse ||
        locationPermission == LocationPermission.always) {
      getCurrentLocation();
    }
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      setState(() {
        locationMessage = "위도: ${position.latitude}, 경도: ${position.longitude}";
        print(locationMessage);
      });
    } catch (e) {
      print(e);
      locationMessage = "위치 정보를 가져오지 못했습니다.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              '현재 위치 정보:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              locationMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                checkLocationService();
              },
              child: const Text('위치 정보 가져오기'),
            ),
          ],
        ),
      ),
    );
  }
}
