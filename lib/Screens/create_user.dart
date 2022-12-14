import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:navigation/Screens/list_screen.dart';

import '../main.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  CreateUserScreenState createState() => CreateUserScreenState();
}

class CreateUserScreenState extends State<CreateUserScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showDate = true;

  XFile? imageFile;

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
    Future<DateTime> _selectDate(BuildContext context) async {
      final selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025),
      );
      if (selected != null && selected != selectedDate) {
        setState(() {
          selectedDate = selected;
        });
      }
      return selectedDate;
    }

    String getDate() {
      return DateFormat('yMd').format(selectedDate);
    }

    return SingleChildScrollView(
      child: Container(
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
                'Create User',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            textInput(
              'Name',
              'enter name',
              nameController,
            ),
            textInput(
              'Password',
              'enter password',
              passwordController,
            ),
            Row(
              children: [
                Text('Tanggal Lahir'),
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(getDate()),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20,
                bottom: 10,
              ),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    var file = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);

                                    setState(() {
                                      imageFile = file;
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.camera),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    var file = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    setState(() {
                                      imageFile = file;
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.browse_gallery),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Text('Upload Foto'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: DropdownButton(
                items: dropdownItems,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  }
                },
                value: selectedValue,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  createUser();
                },
                child: Text('Create User'),
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

  Future<void> createUser() async {
    try {
      var formData = FormData.fromMap({
        'namakaryawan': nameController.text,
        'tanggal': DateFormat('yMd').format(selectedDate),
        'nid': '6122132W',
        'password': passwordController.text,
        'level': selectedValue,
        'foto': await MultipartFile.fromFile(imageFile!.path,
            contentType: MediaType('image', 'jpg'), filename: imageFile!.name),
      });

      var response = await Dio().post(
        'http://nusantarapowerrembang.com/flutter/simpankaryawan.php',
        data: formData,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Register User Sukses'),
          backgroundColor: Colors.blue,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyHomePage(widgetBefore: ListScreen(), title: 'Demo'),
        ),
      );

      print("response: $response");
    } on DioError catch (e) {
      print("error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Register User Gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
