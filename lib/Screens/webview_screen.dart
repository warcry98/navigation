import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  var _url = 'https://10.7.33.176/latihan/';

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
              initialUrlRequest: URLRequest(url: Uri.parse(_url)),
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
