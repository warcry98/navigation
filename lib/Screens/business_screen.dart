import 'package:flutter/material.dart';

class businessScreen extends StatefulWidget {
  const businessScreen({super.key});

  @override
  State<businessScreen> createState() => businessScreenState();
}

class businessScreenState extends State<businessScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Business Screen'),
    );
  }
}
