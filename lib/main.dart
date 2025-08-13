
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'طلب الأذونات',
      home: PermissionScreen(),
    );
  }
}

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final Telephony telephony = Telephony.instance;
  bool _permissionsGranted = false;

  Future<void> _requestPermissions() async {
    var statusStorage = await Permission.storage.request();
    var statusSms = await Permission.sms.request();

    final bool? smsPermissionsGranted = await telephony.requestPhoneAndSmsPermissions;

    if (statusStorage.isGranted && statusSms.isGranted && (smsPermissionsGranted ?? false)) {
      setState(() {
        _permissionsGranted = true;
      });
    } else {
      setState(() {
        _permissionsGranted = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلب الأذونات'),
      ),
      body: Center(
        child: _permissionsGranted
            ? ElevatedButton(
                child: Text('دخول'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                },
              )
            : Text('جاري طلب الأذونات...'),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مرحبا'),
      ),
      body: Center(
        child: Text('مرحباً بك في التطبيق'),
      ),
    );
  }
}
