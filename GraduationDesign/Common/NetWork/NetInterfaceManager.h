//
//  NetInterfaceManager.h
//  GraduationDesign
//
//  Created by Eric on 2018/3/30.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDAFSessionNetworkManger.h"

@interface NetInterfaceManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)wExtraParams:(NSDictionary*)requestExtraParams
        wResultBlock:(QDNetWorkBlock)block;

@end
