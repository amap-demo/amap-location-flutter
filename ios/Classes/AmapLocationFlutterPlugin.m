#import "AmapLocationFlutterPlugin.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "AmapFlutterStreamManager.h"

@interface AMapFlutterLocationManager : AMapLocationManager

@property (nonatomic, assign) BOOL onceLocation;
@property (nonatomic, copy) FlutterResult flutterResult;
@property (nonatomic, strong) NSString *pluginKey;
@property (nonatomic, copy) NSString *fullAccuracyPurposeKey;

@end

@implementation AMapFlutterLocationManager

- (instancetype)init {
    if ([super init] == self) {
        _onceLocation = false;
        _fullAccuracyPurposeKey = nil;
    }
    return self;
}

@end

@interface AmapLocationFlutterPlugin()<AMapLocationManagerDelegate>
@property (nonatomic, strong) NSMutableDictionary<NSString*, AMapFlutterLocationManager*> *pluginsDict;

@end

@implementation AmapLocationFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"amap_location_flutter_plugin"
                                     binaryMessenger:[registrar messenger]];
    AmapLocationFlutterPlugin* instance = [[AmapLocationFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    //AmapFlutterStreamHandler * streamHandler = [[AmapFlutterStreamHandler alloc] init];
    FlutterEventChannel *eventChanel = [FlutterEventChannel eventChannelWithName:@"amap_location_flutter_plugin_stream" binaryMessenger:[registrar messenger]];
    [eventChanel setStreamHandler:[[AmapFlutterStreamManager sharedInstance] streamHandler]];
        
}

- (instancetype)init {
    if ([super init] == self) {
        _pluginsDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"startLocation" isEqualToString:call.method]){
        [self startLocation:call result:result];
    }else if ([@"stopLocation" isEqualToString:call.method]){
        [self stopLocation:call];
        result(@YES);
    }else if ([@"setLocationOption" isEqualToString:call.method]){
        [self setLocationOption:call];
    }else if ([@"destroy" isEqualToString:call.method]){
        [self destroyLocation:call];
    }else if ([@"setApiKey" isEqualToString:call.method]){
        NSString *apiKey = call.arguments[@"ios"];
        if (apiKey && [apiKey isKindOfClass:[NSString class]]) {
            [AMapServices sharedServices].apiKey = apiKey;
            result(@YES);
        }else {
            result(@NO);
        }
    }else if ([@"getSystemAccuracyAuthorization" isEqualToString:call.method]) {
        if (@available(iOS 14.0, *)) {
            [self getSystemAccuracyAuthorization:call result:result];
        }
    }else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)getSystemAccuracyAuthorization:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (@available(iOS 14.0, *)) {
        AMapFlutterLocationManager *manager = [self locManagerWithCall:call];
        CLAccuracyAuthorization curacyAuthorization = [manager currentAuthorization];
        result(@(curacyAuthorization));
    }
}

- (void)startLocation:(FlutterMethodCall*)call result:(FlutterResult)result
{
    AMapFlutterLocationManager *manager = [self locManagerWithCall:call];
    if (!manager) {
        return;
    }

    if (manager.onceLocation) {
        [manager requestLocationWithReGeocode:manager.locatingWithReGeocode completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            [self handlePlugin:manager.pluginKey location:location reGeocode:regeocode error:error];
        }];
    } else {
        [manager setFlutterResult:result];
        [manager startUpdatingLocation];
    }
}

- (void)stopLocation:(FlutterMethodCall*)call
{
    AMapFlutterLocationManager *manager = [self locManagerWithCall:call];
    if (!manager) {
        return;
    }

    [manager setFlutterResult:nil];
    [[self locManagerWithCall:call] stopUpdatingLocation];
}

- (void)setLocationOption:(FlutterMethodCall*)call
{
    AMapFlutterLocationManager *manager = [self locManagerWithCall:call];
    if (!manager) {
        return;
    }
    
    NSNumber *needAddress = call.arguments[@"needAddress"];
    if (needAddress) {
        [manager setLocatingWithReGeocode:[needAddress boolValue]];
    }
        
    NSNumber *geoLanguage = call.arguments[@"geoLanguage"];
    if (geoLanguage) {
        if ([geoLanguage integerValue] == 0) {
            [manager setReGeocodeLanguage:AMapLocationReGeocodeLanguageDefault];
        } else if ([geoLanguage integerValue] == 1) {
            [manager setReGeocodeLanguage:AMapLocationReGeocodeLanguageChinse];
        } else if ([geoLanguage integerValue] == 2) {
            [manager setReGeocodeLanguage:AMapLocationReGeocodeLanguageEnglish];
        }
    }

    NSNumber *onceLocation = call.arguments[@"onceLocation"];
    if (onceLocation) {
        manager.onceLocation = [onceLocation boolValue];
    }

    NSNumber *pausesLocationUpdatesAutomatically = call.arguments[@"pausesLocationUpdatesAutomatically"];
    if (pausesLocationUpdatesAutomatically) {
        [manager setPausesLocationUpdatesAutomatically:[pausesLocationUpdatesAutomatically boolValue]];
    }
    
    NSNumber *desiredAccuracy = call.arguments[@"desiredAccuracy"];
    if (desiredAccuracy) {
        
        if (desiredAccuracy.integerValue == 0) {
            [manager setDesiredAccuracy:kCLLocationAccuracyBest];
        } else if (desiredAccuracy.integerValue == 1){
            [manager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        } else if (desiredAccuracy.integerValue == 2){
            [manager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        } else if (desiredAccuracy.integerValue == 3){
            [manager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        } else if (desiredAccuracy.integerValue == 4){
            [manager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        } else if (desiredAccuracy.integerValue == 5){
            [manager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        }
    }
    
    NSNumber *distanceFilter = call.arguments[@"distanceFilter"];
    if (distanceFilter) {
        if (distanceFilter.doubleValue == -1) {
            [manager setDistanceFilter:kCLDistanceFilterNone];
        } else if (distanceFilter.doubleValue > 0) {
            [manager setDistanceFilter:distanceFilter.doubleValue];
        }
    }

    if (@available(iOS 14.0, *)) {
        NSNumber *accuracyAuthorizationMode = call.arguments[@"locationAccuracyAuthorizationMode"];
        if (accuracyAuthorizationMode) {
            if ([accuracyAuthorizationMode integerValue] == 0) {
                [manager setLocationAccuracyMode:AMapLocationFullAndReduceAccuracy];
            } else if ([accuracyAuthorizationMode integerValue] == 1) {
                [manager setLocationAccuracyMode:AMapLocationFullAccuracy];
            } else if ([accuracyAuthorizationMode integerValue] == 2) {
                [manager setLocationAccuracyMode:AMapLocationReduceAccuracy];
            }
        }
        
        NSString *fullAccuracyPurposeKey = call.arguments[@"fullAccuracyPurposeKey"];
        if (fullAccuracyPurposeKey) {
            manager.fullAccuracyPurposeKey = fullAccuracyPurposeKey;
        }
    }
}

- (void)destroyLocation:(FlutterMethodCall*)call
{
    AMapFlutterLocationManager *manager = [self locManagerWithCall:call];
    if (!manager) {
        return;
    }
    
    @synchronized (self) {
        if (manager.pluginKey) {
            [_pluginsDict removeObjectForKey:manager.pluginKey];
        }
    }
    
}

- (void)handlePlugin:(NSString *)pluginKey location:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode error:(NSError *)error
{
    if (!pluginKey || ![[AmapFlutterStreamManager sharedInstance] streamHandler].eventSink) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[self getFormatTime:[NSDate date]] forKey:@"callbackTime"];
    [dic setObject:pluginKey forKey:@"pluginKey"];
    
    if (location) {
        [dic setObject:[self getFormatTime:location.timestamp] forKey:@"locTime"];
        [dic setValue:@1 forKey:@"locationType"];
        [dic setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];
        [dic setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];
        [dic setValue:[NSNumber numberWithDouble:location.horizontalAccuracy] forKey:@"accuracy"];
        [dic setValue:[NSNumber numberWithDouble:location.altitude] forKey:@"altitude"];
        [dic setValue:[NSNumber numberWithDouble:location.course] forKey:@"bearing"];
        [dic setValue:[NSNumber numberWithDouble:location.speed] forKey:@"speed"];
        
        if (reGeocode) {
            if (reGeocode.country) {
                [dic setValue:reGeocode.country forKey:@"country"];
            }
            
            if (reGeocode.province) {
                [dic setValue:reGeocode.province forKey:@"province"];
            }
            
            if (reGeocode.city) {
                [dic setValue:reGeocode.city forKey:@"city"];
            }
            
            if (reGeocode.district) {
                [dic setValue:reGeocode.district forKey:@"district"];
            }
            
            if (reGeocode.street) {
                [dic setValue:reGeocode.street forKey:@"street"];
            }
            
            if (reGeocode.number) {
                [dic setValue:reGeocode.number forKey:@"streetNumber"];
            }
            
            if (reGeocode.citycode) {
                [dic setValue:reGeocode.citycode forKey:@"cityCode"];
            }

            if (reGeocode.adcode) {
                [dic setValue:reGeocode.adcode forKey:@"adCode"];
            }
            
            if (reGeocode.description) {
                [dic setValue:reGeocode.formattedAddress forKey:@"description"];
            }
                        
            if (reGeocode.formattedAddress.length) {
                [dic setObject:reGeocode.formattedAddress forKey:@"address"];
            }
        }
        
    } else {
        [dic setObject:@"-1" forKey:@"errorCode"];
        [dic setObject:@"location is null" forKey:@"errorInfo"];
        
    }
    
    if (error) {
        [dic setObject:[NSNumber numberWithInteger:error.code]  forKey:@"errorCode"];
        [dic setObject:error.description forKey:@"errorInfo"];
    }
    
    [[AmapFlutterStreamManager sharedInstance] streamHandler].eventSink(dic);
    //NSLog(@"x===%f,y===%f",location.coordinate.latitude,location.coordinate.longitude);
}

- (AMapFlutterLocationManager *)locManagerWithCall:(FlutterMethodCall*)call {
    
    if (!call || !call.arguments || !call.arguments[@"pluginKey"] || [call.arguments[@"pluginKey"] isKindOfClass:[NSString class]] == NO) {
        return nil;
    }
    
    NSString *pluginKey = call.arguments[@"pluginKey"];
    
    AMapFlutterLocationManager *manager = nil;
    @synchronized (self) {
            manager = [_pluginsDict objectForKey:pluginKey];
    }
    
    if (!manager) {
        manager = [[AMapFlutterLocationManager alloc] init];
        manager.pluginKey = pluginKey;
        manager.locatingWithReGeocode = YES;
        manager.delegate = self;
        @synchronized (self) {
            [_pluginsDict setObject:manager forKey:pluginKey];
        }
    }
    return manager;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000

/**
 *  @brief 当plist配置NSLocationTemporaryUsageDescriptionDictionary且desiredAccuracyMode设置CLAccuracyAuthorizationFullAccuracy精确定位模式时，如果用户只授权模糊定位，会调用代理的此方法。此方法实现调用申请临时精确定位权限API即可：
 *  [manager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"PurposeKey" completion:^(NSError *error){
 *     if(completion){
 *        completion(error);
 *     }
 *  }]; (必须调用,不然无法正常获取临时精确定位权限)
 *  @param manager 定位 AMapLocationManager 类。
 *  @param locationManager 需要申请临时精确定位权限的locationManager。
 *  @param completion 临时精确定位权限API回调结果，error: 直接返回系统error即可。
 *  @since 2.6.7
 */
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireTemporaryFullAccuracyAuth:(CLLocationManager*)locationManager completion:(void(^)(NSError *error))completion {
    if (@available(iOS 14.0, *)) {
        if ([manager isKindOfClass:[AMapFlutterLocationManager class]]) {
            AMapFlutterLocationManager *flutterLocationManager = (AMapFlutterLocationManager*)manager;
            if (flutterLocationManager.fullAccuracyPurposeKey && [flutterLocationManager.fullAccuracyPurposeKey length] > 0) {
                NSDictionary *locationTemporaryDictionary = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationTemporaryUsageDescriptionDictionary"];
                BOOL hasLocationTemporaryKey = locationTemporaryDictionary != nil && locationTemporaryDictionary.count != 0;
                if (hasLocationTemporaryKey) {
                    if ([locationTemporaryDictionary objectForKey:flutterLocationManager.fullAccuracyPurposeKey]) {
                        [locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:flutterLocationManager.fullAccuracyPurposeKey completion:^(NSError * _Nullable error) {
                            if (completion) {
                                completion(error);
                            }
                   
                        }];
                    } else {
                        NSLog(@"[AMapLocationKit] 要在iOS 14及以上版本使用精确定位, 在amap_location_option.dart 中配置的fullAccuracyPurposeKey的key不包含在infoPlist中,请检查配置的key是否正确");
                    }
                } else {
                    NSLog(@"[AMapLocationKit] 要在iOS 14及以上版本使用精确定位, 需要在Info.plist中添加NSLocationTemporaryUsageDescriptionDictionary字典，且自定义Key描述精确定位的使用场景。");
                }
        
            } else {
                NSLog(@"[AMapLocationKit] 要在iOS 14及以上版本使用精确定位, 需要在amap_location_option.dart 中配置对应场景下fullAccuracyPurposeKey的key。注意：这个key要和infoPlist中的配置一样");
            }
        }
    }
}
#endif

/**
 *  @brief 当plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription，并且[CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined，会调用代理的此方法。
     此方法实现调用申请后台权限API即可：[locationManager requestAlwaysAuthorization](必须调用,不然无法正常获取定位权限)
 *  @param manager 定位 AMapLocationManager 类。
 *  @param locationManager  需要申请后台定位权限的locationManager。
 *  @since 2.6.2
 */
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager
{
    [locationManager requestWhenInUseAuthorization];
}

 /**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    [self handlePlugin:((AMapFlutterLocationManager *)manager).pluginKey location:nil reGeocode:nil error:error];
}


/**
 *  @brief 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 *  @param reGeocode 逆地理信息。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    [self handlePlugin:((AMapFlutterLocationManager *)manager).pluginKey location:location reGeocode:reGeocode error:nil];
}

- (NSString *)getFormatTime:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

@end
