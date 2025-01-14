import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic SMS Receiver',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SmsReceiverScreen(),
    );
  }
}

class SmsReceiverScreen extends StatefulWidget {
  @override
  _SmsReceiverScreenState createState() => _SmsReceiverScreenState();
}

class _SmsReceiverScreenState extends State<SmsReceiverScreen> {
  final Telephony telephony = Telephony.instance;
  String _receivedSms = "No SMS received yet.";

  @override
  void initState() {
    super.initState();
    requestPermissionsAndStartListening();
  }

  void requestPermissionsAndStartListening() async {
    final isGranted = await telephony.requestSmsPermissions;

    if (isGranted ?? false) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          setState(() {
            _receivedSms = "From: ${message.address}\nMessage: ${message.body}";
          });
        },
        onBackgroundMessage: _backgroundMessageHandler, // Optional
      );
    } else {
      setState(() {
        _receivedSms = "Permission denied. Cannot listen to SMS.";
      });
    }
  }

  static void _backgroundMessageHandler(SmsMessage message) {
    // Handle SMS in the background
    print("Background SMS received: ${message.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SMS Receiver")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Received SMS:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(_receivedSms, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
