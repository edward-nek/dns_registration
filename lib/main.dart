import 'package:dns_registration/screens/registration.dart';
import 'package:flutter/material.dart';
import 'screens/inputData.dart';

void main() => runApp(TestDNSApp());

class TestDNSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration DNS',
      home: InputDataPage(),
    );
  }
}
