import 'package:flutter/material.dart';

class testScreen extends StatefulWidget {
  const testScreen({super.key});

  @override
  State<testScreen> createState() => testScreenState();
}

class testScreenState extends State<testScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Test Screen'),
    );
  }
}
