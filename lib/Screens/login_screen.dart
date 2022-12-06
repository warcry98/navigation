import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Screens/business_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.update, super.key});

  final Function update;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 50,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: 12,
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          textInput(
            'User Id',
            'enter userid',
            userIdController,
          ),
          textInput(
            'Password',
            'enter password',
            passwordController,
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                doLogin();
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.only(
                  left: 40,
                  right: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textInput(
    inputName,
    hintText,
    controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(inputName),
        Container(
          alignment: Alignment.center,
          height: 40,
          margin: EdgeInsets.only(
            top: 10,
            bottom: 20,
          ),
          child: TextFormField(
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.only(
                  left: 12,
                  top: 0,
                  bottom: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
          ),
        ),
      ],
    );
  }

  Future<void> doLogin() async {
    var formData = FormData.fromMap({
      "userid": userIdController.text,
      "psw": passwordController.text,
      "op": "login",
    });

    var response = await Dio().post(
      'http://nusantarapowerrembang.com/flutter/log1.php',
      data: formData,
    );

    // print(response.data);
    Map<String, dynamic> data =
        jsonDecode(response.data) as Map<String, dynamic>;

    String level = data['level'];

    if (level == "User") {
      // Navigator.pushNamed(context, '/LoggedUser');
      widget.update(businessScreen());
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Failed')));
    }
  }
}
