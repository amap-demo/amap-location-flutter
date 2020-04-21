import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';

/// 定位参数设置
class AMapLocationOption {
  /// 是否需要地址信息，默认true
  bool needAddress = true;

  ///逆地理信息语言类型<br>
  ///默认[GeoLanguage.DEFAULT] 自动适配<br>
  ///可选值：<br>
  ///<li>[GeoLanguage.DEFAULT] 自动适配</li>
  ///<li>[GeoLanguage.EN] 英文</li>
  ///<li>[GeoLanguage.ZH] 中文</li>
  GeoLanguage geoLanguage;

  ///是否单次定位
  ///默认值：false
  bool onceLocation = false;

  ///Android端定位模式, 只在Android系统上有效<br>
  ///默认值：[AMapLocationMode.Hight_Accuracy]<br>
  ///可选值：<br>
  ///<li>[AMapLocationMode.Battery_Saving]</li>
  ///<li>[AMapLocationMode.Device_Sensors]</li>
  ///<li>[AMapLocationMode.Hight_Accuracy]</li>
  AMapLocationMode locationMode;

  ///Android端定位间隔<br>
  ///单位：毫秒<br>
  ///默认：2000毫秒<br>
  int locationInterval = 2000;

  ///iOS端是否允许系统暂停定位<br>
  ///默认：false
  bool pausesLocationUpdatesAutomatically = false;

  /// iOS端期望的定位精度， 只在iOS端有效<br>
  /// 默认值：最高精度<br>
  /// 可选值：<br>
  /// <li>[DesiredAccuracy.Best] 最高精度</li>
  /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
  /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
  /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
  /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
  DesiredAccuracy desiredAccuracy = DesiredAccuracy.Best;

  /// iOS端定位最小更新距离<br>
  /// 单位：米<br>
  /// 默认值：-1，不做限制<br>
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

  ///获取设置的定位参数对应的Map
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

///Android端定位模式
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

///iOS中期望的定位精度
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
