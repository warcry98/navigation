import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  List dataKaryawan = [];

  final scrollController = ScrollController();
  bool loading = false;
  int page = 0;
  int total = 0;

  bool editData = false;
  bool deleteData = false;

  @override
  void initState() {
    super.initState();

    getList();
    scrollController.addListener(pagination);
  }

  void pagination() {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) &&
        (dataKaryawan.length < total)) {
      setState(() {
        loading = true;
        page += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 600,
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: dataKaryawan.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(
                  top: 6,
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _editButton(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dataKaryawan[0]['namakaryawan'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          dataKaryawan[0]['nid'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          dataKaryawan[0]['tanggal'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    _deleteData(),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  editData = true;
                });
                print("editData: $editData");
              },
              child: Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  deleteData = true;
                });
              },
              child: Text('Delete'),
            ),
          ],
        )
      ],
    );
  }

  Widget _deleteData() {
    if (deleteData) {
      return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      );
    } else {
      return SizedBox(
        width: 50,
      );
    }
  }

  Widget _editButton() {
    if (editData) {
      return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.edit,
          color: Colors.red,
        ),
      );
    } else {
      return SizedBox(
        width: 50,
      );
    }
  }

  Future<void> getList() async {
    var formData;
    var response = await Dio()
        .get('http://nusantarapowerrembang.com/flutter/viewkaryawan.php');
    List data = json.decode(response.data);
    setState(() {
      dataKaryawan = data;
      total = data.length;
    });
    print("dataKaryawan: $dataKaryawan");
  }
}
