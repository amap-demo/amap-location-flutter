//
//  AmapFlutterStreamManager.h
//  amap_location_flutter_plugin
//
//  Created by ldj on 2018/10/30.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN
@class AmapFlutterStreamHandler;
@interface AmapFlutterStreamManager : NSObject
+ (instancetype)sharedInstance ;
@property (nonatomic, strong) AmapFlutterStreamHandler* streamHandler;

@end

@interface AmapFlutterStreamHandler : NSObject<FlutterStreamHandler>
@property (nonatomic, strong,nullable) FlutterEventSink eventSink;

@end
NS_ASSUME_NONNULL_END
