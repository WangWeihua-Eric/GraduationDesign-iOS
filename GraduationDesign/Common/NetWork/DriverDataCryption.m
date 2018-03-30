//
//  DriverDataCryption.m
//  CommonFramework
//
//  Created by jinfeng.du on 16/10/27.
//  Copyright © 2016年 Qunar.com. All rights reserved.
//

#import "DriverDataCryption.h"
#import "NewCryption.h"

@implementation DriverDataCryption
// 加密方法
+ (NSString *)encryptDriverString:(NSString *)srcString {
//    unsigned char* estr = eLocal([str UTF8String], str.length);
//    unsigned char* dstr = dLocal(estr, strlen(estr));
//    NSString * strPath = [NSString stringWithUTF8String:dstr];
    if (srcString && srcString.length > 0) {
        const char * filePathChar = [srcString UTF8String];
        unsigned char* encrypt = eLocal(filePathChar, strlen(filePathChar));
        NSString *enStr = [NSString stringWithCString:encrypt encoding:NSUTF8StringEncoding];
//        NSLog(@"driver cryption en:%@ -> %@", srcString, enStr);
        
        return enStr;
    }
    
    return nil;
}

// 解密方法
+ (NSString *)decryptDriverData:(NSData *)cryptData {
//    unsigned char* estr = eLocal([str UTF8String], str.length);
//    unsigned char* dstr = dLocal(estr, strlen(estr));
//    NSString * strPath = [NSString stringWithUTF8String:dstr];
    
    if (cryptData && cryptData.length > 0) {
        unsigned char* decrypt = dLocal([cryptData bytes], [cryptData length]);
        NSString * deStr = [NSString stringWithUTF8String:decrypt];
//        NSLog(@"driver cryption de:%@", deStr);
        
        return deStr;
    }
    
    return nil;
}

@end
