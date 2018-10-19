import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amap_location_flutter_plugin/amap_location_flutter_plugin.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, Object> _loationResult;

  StreamSubscription<Map<String, Object>> _locationListener;

  AmapLocationFlutterPlugin _locationPlugin = new AmapLocationFlutterPlugin();


  @override
  void initState() {
    super.initState();
    _locationListener =
        _locationPlugin.onLocationChanged().listen((Map<String, Object> result) {
      setState(() {
        _loationResult = result;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(null != _locationListener) {
      _locationListener.cancel();
    }
  }

  void _startLocation(){
    if(null != _locationPlugin) {
      _locationPlugin.startLocation();
    }
  }

  void _stopLocation() {
    if(null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }

  Container _createButtonContainer(){
    return new Container(
        alignment: Alignment.center,
        child:new Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: _startLocation,
              child: new Text('开始定位'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
            new Container(width: 20.0),
            new RaisedButton(
              onPressed: _stopLocation,
              child: new Text('停止定位'),
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        )
    );
  }


  Widget _resultWidget(key, value) {
     return new Container(
       child: new Row(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           new Container(
             alignment: Alignment.centerRight,
             width: 100.0,
             child: new Text('$key :'),
           ),
           new Container(width: 5.0),
           new Text('$value',softWrap: true )
         ],
       ),
     );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = new List();
    widgets.add(_createButtonContainer());

    if (_loationResult != null) {
      _loationResult.forEach(
          (key, value) {
            widgets.add(_resultWidget(key, value));
          }
      );
    }

    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('AMap Location plugin example app'),
            ),
          body: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: widgets,
          ),
        ));
  }
}
