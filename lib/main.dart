
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

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
  bool _permissionsGranted = false;

  Future<void> _requestPermissions() async {
    var storage = await Permission.storage.request();
    var sms = await Permission.sms.request();

    if (storage.isGranted && sms.isGranted) {
      setState(() {
        _permissionsGranted = true;
      });
    }
  }

  void _sendSMS() {
    SmsSender sender = SmsSender();
    sender.sendSms(SmsMessage("1234567890", "رسالة SMS من مكتبة sms_advanced"));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم إرسال الرسالة")));
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("طلب الأذونات")),
      body: Center(
        child: _permissionsGranted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text("دخول"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _sendSMS,
                    child: Text("إرسال رسالة SMS"),
                  )
                ],
              )
            : Text("جاري طلب الأذونات..."),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("مرحبا")),
      body: Center(child: Text("مرحباً بك في التطبيق")),
    );
  }
}
