//
//  FlightInfosPojo.m
//  GraduationDesign
//
//  Created by Eric on 2018/6/9.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import "FlightInfosPojo.h"

@implementation FlightInfosPojo

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
