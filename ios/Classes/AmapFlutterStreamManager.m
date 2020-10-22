//
//  AmapFlutterStreamManager.m
//  amap_location_flutter_plugin
//
//  Created by ldj on 2018/10/30.
//

#import "AmapFlutterStreamManager.h"

@implementation AmapFlutterStreamManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AmapFlutterStreamManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[AmapFlutterStreamManager alloc] init];
        AmapFlutterStreamHandler * streamHandler = [[AmapFlutterStreamHandler alloc] init];
        manager.streamHandler = streamHandler;
    });
    
    return manager;
}

@end


@implementation AmapFlutterStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.eventSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.eventSink = nil;
    return nil;
}

@end
