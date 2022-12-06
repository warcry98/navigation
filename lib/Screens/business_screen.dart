import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:navigation/Pages/login_page.dart';
import 'package:navigation/Screens/login_screen.dart';
import 'package:navigation/main.dart';

class businessScreen extends StatefulWidget {
  const businessScreen({super.key});

  @override
  State<businessScreen> createState() => businessScreenState();
}

class businessScreenState extends State<businessScreen> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text('User'), value: 'User'),
      DropdownMenuItem(child: Text('Admin'), value: 'Admin')
    ];
    return menuItems;
  }

  String selectedValue = "User";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Business Screen'),
          DropdownButton(
            items: dropdownItems,
            onChanged: (String? newValue) {},
            value: selectedValue,
          ),
          TextButton(
            onPressed: () async {
              await SessionManager().remove('userid');
              await SessionManager().remove('psw');
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         MyHomePage(widgetBefore: LoginScreen(), title: 'Demo'),
              //   ),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
