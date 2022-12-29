import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../Screens/business_screen.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
            top: 50,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
          ),
        ),
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
    try {
      var formData;
      var checkUserId = await SessionManager().containsKey('userid');
      if (checkUserId) {
        formData = FormData.fromMap({
          "userid": await SessionManager().get('userid'),
          "psw": await SessionManager().get('psw'),
          "op": "login",
        });
      } else {
        formData = FormData.fromMap({
          "userid": userIdController.text,
          "psw": passwordController.text,
          "op": "login",
        });
      }

      var response = await Dio().post(
        'http://nusantarapowerrembang.com/flutter/log1.php',
        data: formData,
      );

      // print(response.data);
      var data = jsonDecode(response.data);

      var level;
      if (data != false) {
        level = data['level'];
      }

      if (level != null) {
        await SessionManager().set('userid', userIdController.text);
        await SessionManager().set('pws', passwordController.text);
        // Navigator.pushNamed(context, '/LoggedUser');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyHomePage(widgetBefore: businessScreen(), title: 'Demo'),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Sukses'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
