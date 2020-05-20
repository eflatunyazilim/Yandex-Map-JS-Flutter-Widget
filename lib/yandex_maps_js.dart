
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class YandexJSMap extends StatefulWidget {
  @override
  _YandexJSMapState createState() => _YandexJSMapState();
}

class _YandexJSMapState extends State<YandexJSMap> {

  InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InAppWebView(
        //initialUrl: "https://eflatunyazilim.com/map.html",
        initialFile: "packages/yandex_maps_js/assets/html/map.html",
        onWebViewCreated: (InAppWebViewController controller) {
          _controller = controller;
        }
      )
    );
  }
}
