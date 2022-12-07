import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'list_screen.dart';

class EditUserScreen extends StatefulWidget {
  EditUserScreen({
    required this.idKaryawan,
    required this.namaKaryawan,
    required this.nid,
    required this.tanggal,
    this.foto,
    super.key,
  });

  String idKaryawan;
  String namaKaryawan;
  String? foto;
  String nid;
  String tanggal;

  @override
  State<EditUserScreen> createState() => EditUserScreenState();
}

class EditUserScreenState extends State<EditUserScreen> {
  TextEditingController namaKaryawanController = TextEditingController();
  TextEditingController nidController = TextEditingController();

  late DateTime selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();

  String selectedValue = "User";

  DateTime parseDate() {
    return DateTime.parse(widget.tanggal);
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text('User'), value: 'User'),
      DropdownMenuItem(child: Text('Admin'), value: 'Admin')
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();

    namaKaryawanController.text = widget.namaKaryawan;
    nidController.text = widget.nid;
    setState(() {
      selectedDate = parseDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<DateTime> _selectDate(BuildContext context) async {
      final selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025),
      );
      if (selected != null) {
        print("selected Date: $selected");
        setState(() {
          selectedDate = selected;
        });
      }
      return selectedDate;
    }

    String getDate() {
      return DateFormat('y-M-d').format(selectedDate);
    }

    return Container(
      margin: EdgeInsets.only(
        top: 40,
        left: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama Karyawan'),
          Container(
            height: 40,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: namaKaryawanController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 12,
                  top: 0,
                  bottom: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Text('NID'),
          Container(
            height: 40,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: nidController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 12,
                  top: 0,
                  bottom: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text('Tanggal'),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text(getDate()),
              ),
            ],
          ),
          // Align(
          //   alignment: Alignment.center,
          //   child:

          // ),
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
                updateData();
              },
              child: Text('Submit Data'),
            ),
          ),
        ],
      ),
    );
  }

  // Widget photoPreview() {
  //   if (widget.foto.isEmpty) {

  //   }
  // }

  Future<void> updateData() async {
    try {
      print("id: " + widget.idKaryawan);
      print("Date: " + DateFormat('y-M-d').format(selectedDate));
      var formData = FormData.fromMap({
        'id': int.parse(widget.idKaryawan),
        'namakaryawan': namaKaryawanController.text,
        'tanggal': DateFormat('yMd').format(selectedDate),
        'nid': nidController.text,
        'level': selectedValue,
      });

      var response = await Dio().post(
        'http://nusantarapowerrembang.com/flutter/senteditkaryawan.php',
        data: formData,
      );

      print("response: $response");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update Data User Sukses'),
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

      // print("response: $response");
    } on DioError catch (e) {
      print("error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update Data User Gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
