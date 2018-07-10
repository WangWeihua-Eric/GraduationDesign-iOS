//
//  FlightInfosPojo.h
//  GraduationDesign
//
//  Created by Eric on 2018/6/9.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightInfosPojo : NSObject

@property (nonatomic, strong) NSArray *flightInfoList;

+ (instancetype)sharedInstance;

@end
