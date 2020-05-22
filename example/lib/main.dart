import 'package:flutter/material.dart';
import 'package:yandex_maps_js/yandex_maps_js.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  YandexMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          YandexJSMap(
            onMapCreated: (YandexMapController controller) {
              _controller = controller;
            },
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: (){
                _controller.yandexJSMapState.evaluateJavascript("dragDisable();");
                //_controller.yandexJSMapState.focusLocation(39.7654539,30.474774);
              },
              child: Container(
                height: 50,
                width: 50,
                color: Colors.white,
                child: Icon(Icons.my_location),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 70,
            child: InkWell(
              onTap: (){
                _controller.yandexJSMapState.evaluateJavascript("dragEnable();");
                //_controller.yandexJSMapState.focusLocation(39.7654539,30.474774);
              },
              child: Container(
                height: 50,
                width: 50,
                color: Colors.white,
                child: Icon(Icons.check),
              ),
            ),
          )
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
