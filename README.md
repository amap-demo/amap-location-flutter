##  前述 

1. 高德定位Flutter插件
2. [高德开放平台官网](https://lbs.amap.com/api/)分别申请[Android端](https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key/)和[iOS端](https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key)的key
3. 如需了解高德定位SDK的相关功能，请参阅[Android定位SDK开发指南](http://lbs.amap.com/api/android-location-sdk/locationsummary/)和[iOS定位SDK开发指南](https://lbs.amap.com/api/ios-location-sdk/summary/)
4. 高德定位Flutter插件内部没有集成动态申请权限插件，您可根据自身需要添加相应的权限申请插件。可以参考[permisson_handler](https://github.com/Baseflow/flutter-permission-handler)插件

## 使用高德定位Flutter插件
### 集成高德定位Flutter插件
#### 集成方式：
 * 方式一 github方引用
  1. 在pubspect.yaml的dependencies里添加如下代码
  ``` Java
  amap_location_flutter_plugin:
    git:
      url: https://github.com/amap-demo/amap-location-flutter.git
   ```
  2. 执行``flutter packages get``等待插件下载完成
 * 方式二 下载到本地引用
  1. 下载高德定位Flutter插件源码
  2. 在本地工程目录下创建plugins目录，将下载的目录复制到plugins目录下
  3. 在pubspect.yaml的dependencies里添加如下代码
  ``` Java
  amap_location_flutter_plugin:
    path: plugins/amap-location-flutter
  ```
  4. 执行``flutter packages get``等待插件现在完成
  
#### 常见问题：
1、[在iOS设备上运行或者运行iOS工程遇到： `Invalid `Podfile` file: cannot load such file - /flutter/packages/flutter_tools/bin/podhelper`](https://github.com/flutter/flutter/issues/59522)
```
$ rm ios/Podfile
$ flutter build ios
```

### 在需要的定位功能的页面中引入定位Flutter插件的dart类
``` Dart
import 'package:amap_location_flutter_plugin/amap_location_flutter_plugin.dart';
import 'package:amap_location_flutter_plugin/amap_location_option.dart';
```
## 接口说明

### 设置APIKey
``` Dart
///设置Android和iOS的apikey，建议在开始定位之前设置
///[androidKey] Android平台的key
///[iosKey] ios平台的key
static void setApiKey(String androidKey, String iosKey)
```
### 申请定位权限
``` Dart
/// 申请定位权限
/// 授予定位权限返回true， 否则返回false
Future<bool> requestLocationPermission()
```

### 设置定位参数
``` Dart
 /// 设置定位参数
 void setLocationOption(AMapLocationOption locationOption)
```
> 将您设置的参数传递到原生端对外接口，目前支持以下定位参数
``` Dart
 /// 是否需要地址信息，默认true
  bool needAddress = true;

  ///逆地理信息语言类型
  ///默认[GeoLanguage.DEFAULT] 自动适配
  ///可选值：
  ///[GeoLanguage.DEFAULT] 自动适配
  ///[GeoLanguage.EN] 英文
  ///[GeoLanguage.ZH] 中文
  GeoLanguage geoLanguage;

  ///是否单次定位
  ///默认值：false
  bool onceLocation = false;

  ///Android端定位模式, 只在Android系统上有效>
  ///默认值：[AMapLocationMode.Hight_Accuracy]
  ///可选值：
  ///[AMapLocationMode.Battery_Saving]
  ///[AMapLocationMode.Device_Sensors]
  ///[AMapLocationMode.Hight_Accuracy]
  AMapLocationMode locationMode;

  ///Android端定位间隔
  ///单位：毫秒
  ///默认：2000毫秒
  int locationInterval = 2000;

  ///iOS端是否允许系统暂停定位
  ///默认：false
  bool pausesLocationUpdatesAutomatically = false;

  /// iOS端期望的定位精度， 只在iOS端有效
  /// 默认值：最高精度
  /// 可选值：
  /// [DesiredAccuracy.Best] 最高精度
  /// [DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 
  /// [DesiredAccuracy.NearestTenMeters] 10米 
  /// [DesiredAccuracy.Kilometer] 1000米
  /// [DesiredAccuracy.ThreeKilometers] 3000米<
  DesiredAccuracy desiredAccuracy = DesiredAccuracy.Best;

  /// iOS端定位最小更新距离
  /// 单位：米
  /// 默认值：-1，不做限制
  double distanceFilter = -1;
```
### 开始定位
``` Dart
void startLocation()
```
### 停止定位
``` Dart
void stopLocation()
```
### 销毁定位
> 高德定位Flutter插件，支持多实例，请在weidet执行dispose()时调用当前定位插件的销毁方法
``` Dart
void destroy()
```
### 定位结果获取
> 原生端以键值对map的形式回传定位结果到Flutter端, 通过onLoationChanged返回定位结果
``` Dart
Stream<Map<String, Object>> onLocationChanged(）
```
> 注册定位结果监听
``` Dart
_locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
          ///result即为定位结果
        }
```

  
## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).


