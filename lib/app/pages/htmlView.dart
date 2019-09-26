import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
//import 'package:webview_flutter/webview_flutter.dart';

class WebViewTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebViewTestState();
  }
}

class _WebViewTestState extends State<WebViewTest> {
  
  //WebViewController _webViewController;
  String filePath = 'lib/app/assets/files/test.html';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Webview Demo')),
      body: nullwedget(),
    /*WebView(
        initialUrl: '',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _loadHtmlFromAssets();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _webViewController.evaluateJavascript('add(10, 10)');
        },
      ),*/
    );
  }

Widget nullwedget(){
  return new Center();
}
/*
  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
  */
}