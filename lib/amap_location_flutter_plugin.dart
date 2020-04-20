import 'dart:async';

import 'package:amap_location_flutter_plugin/amap_location_option.dart';
import 'package:flutter/services.dart';

class AmapLocationFlutterPlugin {
  static const String _CHANNEL_METHOD_LOCATION = "amap_location_flutter_plugin";
  static const String _CHANNEL_STREAM_LOCATION =
      "amap_location_flutter_plugin_stream";

  static const MethodChannel _methodChannel =
      const MethodChannel(_CHANNEL_METHOD_LOCATION);

  static const EventChannel _eventChannel =
      const EventChannel(_CHANNEL_STREAM_LOCATION);

  static Stream<Map<String, Object>> _onLocationChanged = _eventChannel
      .receiveBroadcastStream()
      .asBroadcastStream()
      .map<Map<String, Object>>((element) => element.cast<String, Object>());

  StreamController<Map<String, Object>> _receiveStream;
  String _pluginKey;

  AmapLocationFlutterPlugin() {
    _pluginKey = DateTime.now().millisecondsSinceEpoch.toString();
  }

  ///开始定位
  void startLocation() {
    _methodChannel.invokeMethod('startLocation', {'pluginKey': _pluginKey});
    return;
  }

  ///停止定位
  void stopLocation() {
    _methodChannel.invokeMethod('stopLocation', {'pluginKey': _pluginKey});
    return;
  }

  ///销毁定位
  void destroy() {
    _methodChannel.invokeMethod('destroy', {'pluginKey': _pluginKey});
  }

  ///设置apikey
  ///androidKey Android平台的key
  ///iosKey ios平台的key
  static void setApiKey(String androidKey, String iosKey) {
    _methodChannel.invokeMethod('setApiKey',
        {'android': androidKey, 'ios': iosKey});
  }

  /// 设置定位参数
  void setLocationOption(AMapLocationOption locationOption) {
    Map option = locationOption.getOptionsMap();
    option['pluginKey'] = _pluginKey;
    _methodChannel.invokeMethod('setLocationOption', option);
  }


  Stream<Map<String, Object>> onLocationChanged() {
    if (_receiveStream == null) {
      _receiveStream = StreamController();
      _onLocationChanged.listen((Map<String, Object> event) {
        if (event != null && event['pluginKey'] == _pluginKey) {
          event.remove('pluginKey');
          _receiveStream.add(event);
        }
      });
    }
    return _receiveStream.stream;
  }
}
