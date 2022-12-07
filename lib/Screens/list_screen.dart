import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Screens/edit_user_screen.dart';
import 'package:navigation/main.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({this.update, super.key});

  final Function? update;

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
          margin: EdgeInsets.only(
            top: 20,
          ),
          height: 350,
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
                    _editButton(index),
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
                    _deleteData(index),
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
                if (editData) {
                  setState(() {
                    editData = false;
                  });
                } else {
                  setState(() {
                    editData = true;
                  });
                }
              },
              child: Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () {
                if (deleteData) {
                  setState(() {
                    deleteData = false;
                  });
                } else {
                  setState(() {
                    deleteData = true;
                  });
                }
              },
              child: Text('Delete'),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _showAlertDelete(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Peringatan Hapus Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Anda akan hapus data?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Tidak');
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                deleteDataUser(index);
                Navigator.pop(context, 'Ya');
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  Widget _deleteData(index) {
    if (deleteData) {
      return IconButton(
        onPressed: () {
          _showAlertDelete(index);
        },
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

  Widget _editButton(int index) {
    if (editData) {
      return IconButton(
        onPressed: () {
          var foto;
          if (dataKaryawan[index]['foto'] != "") {
            foto = 'http://nusantarapowerrembang.com/flutter/foto/' +
                dataKaryawan[index]['foto'] +
                '.jpg';
          } else {
            foto = null;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                    widgetBefore: EditUserScreen(
                      idKaryawan: dataKaryawan[index]['idkaryawan'],
                      namaKaryawan: dataKaryawan[index]['namakaryawan'],
                      nid: dataKaryawan[index]['nid'],
                      foto: foto,
                      tanggal: dataKaryawan[index]['tanggal'],
                    ),
                    title: 'Demo')),
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MyHomePage(
          //       widgetBefore: EditUserScreen(),
          //       title: 'Demo',
          //     ),
          //   ),
          // );
        },
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

  Future<void> deleteDataUser(int index) async {
    try {
      var response = await Dio().get(
        'http://nusantarapowerrembang.com/flutter/deletekaryawan.php',
        queryParameters: {
          'id': dataKaryawan[index]['idkaryawan'],
        },
      );

      print("response: $response");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil dihapus'),
          backgroundColor: Colors.blue,
        ),
      );
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data gagal dihapus'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  Future<void> getList() async {
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
