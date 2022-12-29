import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MirroringUjrb extends StatefulWidget {
  MirroringUjrb({required this.idpage, super.key});

  String idpage;

  @override
  State<MirroringUjrb> createState() => MirroringUjrbState();
}

class MirroringUjrbState extends State<MirroringUjrb> {
  var _url = 'http://nusantarapowerrembang.com/aime/cek.php?idpage=';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(_url + widget.idpage),
              ),
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
            ),
          ),
        ],
      ),
    );
  }
}
