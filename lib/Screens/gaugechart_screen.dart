import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gauges/gauges.dart';

class GaugeChartScreen extends StatefulWidget {
  const GaugeChartScreen({super.key});

  @override
  State<GaugeChartScreen> createState() => GaugeChartScreenState();
}

class GaugeChartScreenState extends State<GaugeChartScreen> {
  double _pointerValue = 0;
  var dataGet;

  @override
  void initState() {
    super.initState();

    getLoad();
  }

  @override
  Widget build(BuildContext context) {
    final size = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) -
        100;

    return Container(
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: RadialGauge(
                axes: [
                  // Main axis
                  RadialGaugeAxis(
                    minValue: 0,
                    maxValue: 100,
                    minAngle: -90,
                    maxAngle: 90,
                    radius: 0.6,
                    width: 0.2,
                    color: Colors.lightBlue[200],
                    ticks: [
                      RadialTicks(
                          interval: 50,
                          alignment: RadialTickAxisAlignment.inside,
                          color: Colors.black,
                          length: 0.2,
                          children: [
                            RadialTicks(
                              ticksInBetween: 5,
                              length: 0.1,
                              color: Colors.blueGrey,
                            ),
                          ])
                    ],
                    pointers: [
                      RadialNeedlePointer(
                        value: _pointerValue,
                        thicknessStart: 20,
                        thicknessEnd: 0,
                        color: Colors.lightBlue[200]!,
                        length: 0.6,
                        knobRadiusAbsolute: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(height: 24),
          // Slider(
          //     value: _pointerValue,
          //     min: -100,
          //     max: 0,
          //     onChanged: (value) {
          //       setState(() {
          //         _pointerValue = value;
          //       });
          //     }),
          // SizedBox(height: 12),
          // Text(_pointerValue.round().toString())
        ],
      ),
    );
  }

  Future getLoad() async {
    try {
      var request = await Dio().get(
        'http://nusantarapowerrembang.com/flutter/load.php',
      );

      print('request: ' + request.data[0]);
      // print(request.data[0]);
      // List data = json.decode(request.data).cast<String>().toList();
      // print('data: $data');
      // setState(() {
      //   _pointerValue = double.parse(request.data[0]['UNIT10']);
      // });

      // setState(() {
      //   _pointerValue = request.data[0]['UNIT10'];
      // });
      // var data = dataGet = [
      //   {"UNIT10": "30"}
      // ];
      // setState(() {
      //   _pointerValue = double.parse(dataGet[0]['UNIT10']);
      // });
      // print(dataGet[0]['UNIT10']);
      // print(jsonDecode(request.data));
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal load Data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
