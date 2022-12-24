import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:at_gauges/at_gauges.dart';

class GaugeChartScreen extends StatefulWidget {
  const GaugeChartScreen({super.key});

  @override
  State<GaugeChartScreen> createState() => GaugeChartScreenState();
}

class GaugeChartScreenState extends State<GaugeChartScreen> {
  double _pointerValue = 0;
  double _defaultValue = 10;

  var dataGet;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) -
        100;

    return Center(
        child: FutureBuilder(
            future: getLoad(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        width: size,
                        height: size,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ScaleRadialGauge(
                            maxValue: 100,
                            actualValue: double.parse(
                              snapshot.data![0]['UNIT10'],
                            ),
                            minValue: 0,
                            title: Text('Gauge Chart'),
                            titlePosition: TitlePosition.top,
                            pointerColor: Colors.blue,
                            needleColor: Colors.red,
                            decimalPlaces: 0,
                            isAnimate: true,
                            animationDuration: 2000,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            }));
  }

  Future<List> getLoad() async {
    try {
      var response =
          await Dio().get('http://nusantarapowerrembang.com/flutter/load.php');

      var data = jsonDecode(response.data);

      debugPrint('data: ${data[0]['UNIT10']}');

      return data;
    } on DioError catch (e) {
      return Future.error(e.toString());
    }
  }
}
