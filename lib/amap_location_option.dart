import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class AMapLocationOption {


  /// 是否需要地址信息，默认true
  bool needAddress = true;

  ///逆地理信息语言类型，默认中文
  GeoLanguage geoLanguage;

  ///是否单次定位
  bool onceLocation = false;

  ///定位模式, 只在Android系统上有效
  AMapLocationMode locationMode;

  /// 定位间隔， 单位毫秒，默认2000
  int locationInterval = 2000;

  ///是否允许系统暂停定位， 默认false， 只对iOS端有效
  bool pausesLocationUpdatesAutomatically = false;

  /// 期望的定位精度， 只在iOS端有效
  /// 默认值：最高精度
  /// 可选值：
  /// DesiredAccuracy.Best 最高精度
  /// DesiredAccuracy.BestForNavigation 适用于导航场景的高精度
  /// DesiredAccuracy.NearestTenMeters: 10米
  /// DesiredAccuracy.Kilometer: 1000米
  /// DesiredAccuracy.ThreeKilometers : 3000米
  ///
  DesiredAccuracy desiredAccuracy = DesiredAccuracy.Best;

  /// 定位最小更新距离, 单位：米
  /// 只在iOS系统上有效
  /// 如果使用系统默认，请设置为-1
  double distanceFilter = -1;

  AMapLocationOption(
      {this.locationInterval = 2000,
      this.needAddress = true,
      this.locationMode = AMapLocationMode.Hight_Accuracy,
      this.geoLanguage = GeoLanguage.DEFAULT,
      this.onceLocation = false,
      this.pausesLocationUpdatesAutomatically = false,
      this.desiredAccuracy = DesiredAccuracy.Best,
      this.distanceFilter = -1});

  Map getOptionsMap() {
    return {
      "locationInterval": this.locationInterval,
      "needAddress": needAddress,
      "locationMode": locationMode.index,
      "geoLanguage": geoLanguage.index,
      "onceLocation": onceLocation,
      "pausesLocationUpdatesAutomatically": pausesLocationUpdatesAutomatically,
      "desiredAccuracy": desiredAccuracy.index,
      'distanceFilter': distanceFilter
    };
  }
}

///定位模式，只在Android端生效
enum AMapLocationMode {
  /// 低功耗模式
  Battery_Saving,

  /// 仅设备模式,不支持室内环境的定位
  Device_Sensors,

  /// 高精度模式
  Hight_Accuracy
}

///逆地理信息语言
enum GeoLanguage {
  /// 默认，自动适配
  DEFAULT,

  /// 汉语，无论在国内还是国外都返回英文
  ZH,

  /// 英语，无论在国内还是国外都返回中文
  EN
}

///iOS中期望的定位精度， 只在iOS端生效
enum DesiredAccuracy {
  ///最高精度
  Best,
  ///适用于导航场景的高精度
  BestForNavigation,
  ///10米
  NearestTenMeters,
  ///100米
  HundredMeters,
  ///1000米
  Kilometer,
  ///3000米
  ThreeKilometers,
}
