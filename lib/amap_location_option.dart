
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

  ///iOS 14中设置期望的定位精度权限
  AMapLocationAccuracyAuthorizationMode desiredLocationAccuracyAuthorizationMode = AMapLocationAccuracyAuthorizationMode.FullAccuracy;

  /// iOS 14中定位精度权限由模糊定位升级到精确定位时，需要用到的场景key fullAccuracyPurposeKey 这个key要和plist中的配置一样
  String fullAccuracyPurposeKey = "";

  AMapLocationOption(
      {
        this.locationInterval = 2000,
        this.needAddress = true,
        this.locationMode = AMapLocationMode.Hight_Accuracy,
        this.geoLanguage = GeoLanguage.DEFAULT,
        this.onceLocation = false,
        this.pausesLocationUpdatesAutomatically = false,
        this.desiredAccuracy = DesiredAccuracy.Best,
        this.distanceFilter = -1,
        this.desiredLocationAccuracyAuthorizationMode = AMapLocationAccuracyAuthorizationMode.FullAccuracy});

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
      'distanceFilter': distanceFilter,
      "locationAccuracyAuthorizationMode": desiredLocationAccuracyAuthorizationMode.index,
      "fullAccuracyPurposeKey":fullAccuracyPurposeKey
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

///iOS 14中期望的定位精度,只有在iOS 14的设备上才能生效
enum AMapLocationAccuracyAuthorizationMode {
  ///精确和模糊定位
  FullAndReduceAccuracy,

  ///精确定位
  FullAccuracy,

  ///模糊定位
  ReduceAccuracy
}

///iOS 14中系统的定位类型信息
enum AMapAccuracyAuthorization {
  ///系统的精确定位类型
  AMapAccuracyAuthorizationFullAccuracy,

  ///系统的模糊定位类型
  AMapAccuracyAuthorizationReducedAccuracy,

  ///未知类型
  AMapAccuracyAuthorizationInvalid
}