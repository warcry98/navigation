import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:navigation/Pages/login_page.dart';
import 'package:navigation/Screens/login_screen.dart';
import 'package:navigation/main.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'business_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var timeLoad = const Duration(seconds: 3);
    return Timer(timeLoad, await navigationPage);
  }

  Future<void> navigationPage() async {
    var checkUserId = await SessionManager().containsKey('userid');
    if (checkUserId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyHomePage(widgetBefore: businessScreen(), title: 'Demo'),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              height: 120,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
