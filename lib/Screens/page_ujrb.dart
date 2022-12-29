import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navigation/Screens/edit_user_screen.dart';
import 'package:navigation/main.dart';

import 'mirroring_ujrb.dart';

class PageUjrb extends StatefulWidget {
  const PageUjrb({required this.idsubmenu, super.key});

  final String idsubmenu;

  @override
  State<PageUjrb> createState() => PageUjrbState();
}

class PageUjrbState extends State<PageUjrb> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
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
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          height: 500.h,
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              getList();
              return Future<void>.delayed(const Duration(seconds: 3));
            },
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
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlue,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(dataKaryawan[index]['file']),
                      ),
                      title: Text(dataKaryawan[index]['judulpage']),
                      subtitle: const Text('UJRB'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                          widgetBefore: MirroringUjrb(
                                            idpage: dataKaryawan[index]
                                                ['idpage'],
                                          ),
                                          title: 'MyRIOT')),
                                );
                              },
                              icon: const Icon(Icons.favorite)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getList() async {
    var response = await Dio()
        .get('http://nusantarapowerrembang.com/flutter/viewpageujrb.php');
    List data = jsonDecode(response.data);
    print("data: $data");
    List filteredData = [];
    for (var i = 0; i < data.length; i++) {
      Map dataMap = Map.from(data[i]);
      if (dataMap['idsubmenu'] == widget.idsubmenu.toString()) {
        filteredData.add(dataMap);
      }
    }
    setState(() {
      dataKaryawan = filteredData;
      total = filteredData.length;
    });
    print("dataKaryawan: $dataKaryawan");
  }
}
