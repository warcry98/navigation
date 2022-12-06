import 'package:flutter/material.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => SchoolScreenState();
}

class SchoolScreenState extends State<SchoolScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('School Screen'),
    );
  }
}
