
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
      home: PermissionScreen(),
    );
  }
}

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  static const platform = MethodChannel('sms_channel');

  bool _granted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.sms.request();
    var storage = await Permission.storage.request();
    if (status.isGranted && storage.isGranted) {
      setState(() => _granted = true);
    }
  }

  Future<void> _sendSms() async {
    try {
      final result = await platform.invokeMethod('sendSms', {
        "number": "1234567890",
        "message": "تم إرسال رسالة SMS من Android Java عبر Flutter"
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل الإرسال: \$e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إرسال SMS")),
      body: Center(
        child: _granted
            ? ElevatedButton(
                onPressed: _sendSms,
                child: Text("إرسال رسالة"),
              )
            : Text("جاري طلب الأذونات..."),
      ),
    );
  }
}
