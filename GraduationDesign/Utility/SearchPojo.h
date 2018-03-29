//
//  SearchPojo.h
//  GraduationDesign
//
//  Created by Eric on 2018/3/20.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchPojo : NSObject

@property (nonatomic, strong) NSString *fromAddress;
@property (nonatomic, strong) NSString *toAddress;
@property (nonatomic, strong) NSString *departureTimee;
@property (nonatomic, strong) NSString *seat;

+ (instancetype)sharedInstance;

@end
