
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yandex_maps_js/models/Location.dart';

typedef void MapCreatedCallback(YandexMapController controller);
enum MapType { Map, Satellite, Hybrid }

class YandexJSMap extends StatefulWidget {

  final Location initialLocation;
  final MapCreatedCallback onMapCreated;

  const YandexJSMap({Key key, this.initialLocation, this.onMapCreated}) : super(key: key);

  @override
  _YandexJSMapState createState() => _YandexJSMapState();
}

class _YandexJSMapState extends State<YandexJSMap> {

  InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InAppWebView(
        initialFile: "packages/yandex_maps_js/assets/html/map.html",
        onWebViewCreated: (InAppWebViewController controller) {
          _controller = controller;
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          if(progress == 100)
          {
            //webview oluşturulduktan sonra yandexmap created callback i çağı
            widget.onMapCreated(YandexMapController(this));
          }
        },
      )
    );
  }

  focusLocation(double lat, double lng) {
    _controller.evaluateJavascript(source: "myMap.setType('yandex#map', {checkZoomRange: true});").then((value){
      print('result: $value');
    }, onError: (error){
      print('error: $error');
    });
  }

  setMapType(MapType mapType) {
    String typeStr = "yandex#map";

    switch(mapType){

      case MapType.Map:
        type = "yandex#map";
        break;
      case MapType.Satellite:
        type = "yandex#satellite";
        break;
      case MapType.Hybrid:
        type = "yandex#hybrid";
        break;
    }

    _controller.evaluateJavascript(source: "myMap.setType('$typeStr', {checkZoomRange: true});").then((value){
      print('result: $value');
    }, onError: (error){
      print('error: $error');
    });
  }
}

class YandexMapController {
  final _YandexJSMapState yandexJSMapState;

  YandexMapController(this.yandexJSMapState);
}