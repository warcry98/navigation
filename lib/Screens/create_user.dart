import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
                bottom: 30,
              ),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    // final result = await FilePicker.platform.pickFiles();
                    // if (result == null) return;
                    // files = result.files;
                    // setState(() {});
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
                                    print(imageFile!.name);
                                    print(imageFile!.path);
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
                                    print("imageFile: $imageFile");
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
            DropdownButton(
              items: dropdownItems,
              onChanged: (String? newValue) {},
              value: selectedValue,
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

    print("response: $response");

    print(response.data);
  }
}
