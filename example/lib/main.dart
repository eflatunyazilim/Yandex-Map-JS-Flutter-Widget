import 'package:flutter/material.dart';
import 'package:yandex_maps_js/models/Location.dart';
import 'package:yandex_maps_js/yandex_maps_js.dart';
import 'package:yandex_maps_js/models/Polygon.dart';

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
              highlightColor: Colors.blue,
              onTap: (){
                _controller.yandexJSMapState.drawPolygon(5, '#00FF00', '#00FFFF', 2, true);
              },
              child: Container(
                height: 50,
                width: 50,
                color: Colors.white,
                child: Icon(Icons.my_location),
              ),
            ),
          ),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  addPolygon(){
    List<Location> list = [];
    list.add(Location(41.29178028941701,36.2408269831327));
    list.add(Location(41.29288482108242,36.24135269609962));
    list.add(Location(41.29202304524475,36.24252750364814));
    list.add(Location(41.29178028941701,36.2408269831327));

    _controller.yandexJSMapState.addPolygon(Polygon(list), '#0000FF55', '#00FF0055', 4, true);
  }
}
