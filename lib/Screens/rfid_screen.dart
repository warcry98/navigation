import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class RFIDScreen extends StatefulWidget {
  const RFIDScreen({super.key});

  @override
  State<RFIDScreen> createState() => _RFIDScreenState();
}

class _RFIDScreenState extends State<RFIDScreen> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<bool>(
        future: NfcManager.instance.isAvailable(),
        builder: (context, snapshot) => snapshot.data != true
            ? Center(
                child: Text('NfcManager.isAvailable(): ${snapshot.data}'),
              )
            : Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: SingleChildScrollView(
                      child: ValueListenableBuilder(
                        valueListenable: result,
                        builder: (context, value, _) {
                          return Text('${value ?? ''}');
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: GridView.count(
                      padding: EdgeInsets.all(4),
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _tagRead();
                          },
                          child: Text('Tag Read'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }
}
