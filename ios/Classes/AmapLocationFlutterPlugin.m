#import "AmapLocationFlutterPlugin.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "AmapFlutterStreamManager.h"

const static NSString *APIKey = @"30cbeb785c52b1b8971b6f0f4ef8b7cc";

@interface AmapLocationFlutterPlugin()<AMapLocationManagerDelegate>
@property (nonatomic,strong) AMapLocationManager *locManager;
@property (nonatomic, copy) FlutterResult flutterResult;

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
    
    [[AMapServices sharedServices] setApiKey:(NSString *)APIKey];
    
    
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"startLocation" isEqualToString:call.method]){
        [self startLocation:result];
    }else if ([@"stopLocation" isEqualToString:call.method]){
        [self stopLocation];
        result(@YES);
    }else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)startLocation:(FlutterResult)result
{
    self.flutterResult = result;
    [self.locManager startUpdatingLocation];
}

- (void)stopLocation
{
    self.flutterResult = nil;
    [self.locManager stopUpdatingLocation];
}

- (AMapLocationManager *)locManager {
    if (!_locManager) {
        _locManager = [[AMapLocationManager alloc] init];
        _locManager.locatingWithReGeocode = YES;
        _locManager.delegate = self;
    }
    return _locManager;
}

/**
 *  @brief 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 *  @param reGeocode 逆地理信息。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    if (![[AmapFlutterStreamManager sharedInstance] streamHandler].eventSink) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[self getFormatTime:[NSDate date]] forKey:@"callbackTime"];
    
    if (location) {
        [dic setObject:[self getFormatTime:location.timestamp] forKey:@"locTime"];
        [dic setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];
        [dic setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];
        if (reGeocode.formattedAddress.length) {
            [dic setObject:reGeocode.formattedAddress forKey:@"address"];
        }
    } else {
        [dic setObject:@"-1" forKey:@"errorCode"];
        [dic setObject:@"location is null" forKey:@"errorInfo"];
        
        
    }
    [[AmapFlutterStreamManager sharedInstance] streamHandler].eventSink(dic);
    //NSLog(@"x===%f,y===%f",location.coordinate.latitude,location.coordinate.longitude);
}

- (NSString *)getFormatTime:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

@end
