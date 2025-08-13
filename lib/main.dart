
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SMSHomePage(),
    );
  }
}

class SMSHomePage extends StatefulWidget {
  @override
  _SMSHomePageState createState() => _SMSHomePageState();
}

class _SMSHomePageState extends State<SMSHomePage> {
  static const platform = MethodChannel('sms_channel');
  bool _granted = false;

  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    var sms = await Permission.sms.request();
    var storage = await Permission.storage.request();
    if (sms.isGranted && storage.isGranted) {
      setState(() => _granted = true);
    }
  }

  Future<void> _sendSMS() async {
    try {
      final result = await platform.invokeMethod('sendSms', {
        'number': '1234567890',
        'message': 'تم إرسال رسالة SMS من Flutter عبر كود Java'
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إرسال SMS')),
      body: Center(
        child: _granted
            ? ElevatedButton(
                onPressed: _sendSMS,
                child: Text('إرسال رسالة'),
              )
            : Text('بانتظار منح الأذونات...'),
      ),
    );
  }
}
