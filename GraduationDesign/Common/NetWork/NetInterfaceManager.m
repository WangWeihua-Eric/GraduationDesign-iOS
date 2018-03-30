//
//  NetInterfaceManager.m
//  GraduationDesign
//
//  Created by Eric on 2018/3/30.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import "NetInterfaceManager.h"
#import "QDMacro.h"

@implementation NetInterfaceManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)wExtraParams:(NSDictionary*)requestExtraParams
        wResultBlock:(QDNetWorkBlock)block
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (requestExtraParams) {
        [param addEntriesFromDictionary:requestExtraParams];
    }
    [[QDAFSessionNetworkManger sharedInstance] startRequestTValue:@"car_qb_driv_sendvcode"
                                                   withServerPath:@"http://localhost:8080/graduation/query/flight/plant"
                                                        withParam:param
                                                      respondData:[QDNetResultBaseModel class]
                                                      resultBlock:block];
    return YES;
}

@end
