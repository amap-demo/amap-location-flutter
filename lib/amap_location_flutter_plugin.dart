import 'dart:async';

import 'package:flutter/services.dart';

class AmapLocationFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('amap_location_flutter_plugin');
  static const EventChannel _stream = const EventChannel("amap_location_flutter_plugin_stream");

  Stream<Map<String,Object>> _onLocationChanged;
  void startLocation() {
    _channel.invokeMethod('startLocation');
    return;
  }

  void stopLocation() {
    _channel.invokeMethod('stopLocation');
    return;
  }

  Stream<Map<String, Object>> onLocationChanged() {
    if (_onLocationChanged == null) {
      _onLocationChanged = _stream
          .receiveBroadcastStream()
          .map<Map<String, Object>>(
              (element) => element.cast<String, Object>());
    }
    return _onLocationChanged;
  }
}
