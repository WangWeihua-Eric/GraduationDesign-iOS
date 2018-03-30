//
//  DriverDataCryption.h
//  CommonFramework
//
//  Created by jinfeng.du on 16/10/27.
//  Copyright © 2016年 Qunar.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverDataCryption : NSObject

// 加密方法
+ (NSString *)encryptDriverString:(NSString *)srcString;

// 解密方法
+ (NSString *)decryptDriverData:(NSData *)cryptData;


@end
