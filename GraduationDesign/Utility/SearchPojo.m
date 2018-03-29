//
//  SearchPojo.m
//  GraduationDesign
//
//  Created by Eric on 2018/3/20.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import "SearchPojo.h"

@implementation SearchPojo

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
