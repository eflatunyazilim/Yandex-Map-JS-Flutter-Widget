import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yandex_maps_js/models/Location.dart';
import 'package:yandex_maps_js/models/Polygon.dart';

typedef void MapCreatedCallback(YandexMapController controller);
typedef void PolygonUpdateCallback();
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

  List<Polygon> _polygons;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InAppWebView(
        initialFile: "packages/yandex_maps_js/assets/html/map.html",
        onWebViewCreated: (InAppWebViewController controller) {
          _controller = controller;

          _controller.addJavaScriptHandler(handlerName:'handlerPolygon', callback: (args) {
            print(args[0]);
          });
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

  evaluateJavascript(String js, {Function(dynamic) onSuccess, Function(dynamic) onError}) {
    _controller.evaluateJavascript(source: js).then((value){
      print('result: $value');
      if(onSuccess != null)
        onSuccess(value);
    }, onError: (error){
      print('error: $error');
      if(onError != null)
        onError(error);
    });
  }

  focusLocation(double lat, double lng) {
    _controller.evaluateJavascript(source: "myMap.setCenter([$lat, $lng], 3, {checkZoomRange: true});").then((value){
      print('result: $value');
    }, onError: (error){
      print('error: $error');
    });
  }

  setMapType(MapType mapType) {
    String typeStr = "yandex#map";

    switch(mapType){
      case MapType.Map:
        typeStr = "yandex#map";
        break;
      case MapType.Satellite:
        typeStr = "yandex#satellite";
        break;
      case MapType.Hybrid:
        typeStr = "yandex#hybrid";
        break;
    }

    _controller.evaluateJavascript(source: "myMap.setType('$typeStr', {checkZoomRange: true});").then((value){
      print('result: $value');
    }, onError: (error){
      print('error: $error');
    });
  }

  dragEnable(Function(dynamic) onSuccess, Function(dynamic) onError) {
    evaluateJavascript("myMap.behaviors.enable('drag');", onSuccess: onSuccess, onError: onError);
  }

  dragDisable(Function(dynamic) onSuccess, Function(dynamic) onError){
    evaluateJavascript("myMap.behaviors.disable('drag');", onSuccess: onSuccess, onError: onError);
  }

  List<Polygon> getPolygons() {
    return _polygons;
  }

  drawPolygon(int pointCount, String fillColor, String strokeColor, int strokeWidth, bool draggable){
    evaluateJavascript("drawPolygon($pointCount, '$fillColor', '$strokeColor', $strokeWidth, ${draggable.toString()});");
  }

  addPolygon(Polygon polygon, String fillColor, String strokeColor, int strokeWidth, bool draggable){
    var points = [];
    for(var point in polygon.points) {
      points.add([point.lat, point.lng]);
    }
    evaluateJavascript("addPolygon(${[points]}, '$fillColor', '$strokeColor', $strokeWidth, ${draggable.toString()});");
  }

  clearPolygons(){
    _polygons.clear();
    evaluateJavascript("clearPolygons();");
  }

}

class YandexMapController {
  final _YandexJSMapState yandexJSMapState;
  YandexMapController(this.yandexJSMapState);
}