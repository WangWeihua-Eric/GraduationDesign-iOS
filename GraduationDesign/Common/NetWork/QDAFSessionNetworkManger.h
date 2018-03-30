//
//  QDAFSessionNetworkManger.h
//  CarDriver
//
//  Created by jinfeng.du on 16/10/28.
//  Copyright © 2016年 Qunar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDNetworkUtility.h"
#import "QDNetResultBaseModel.h"

@interface QDAFSessionNetworkManger : NSObject

+ (instancetype)sharedInstance;

+ (NSString*) driverServerPath;

-(NSDictionary*) getCParam;


/**
 通过请求b参数生成加密后的c&b参数

 @param tValueStr t值
 @param bParams   b参数

 @return 加密后的POST数据
 */
- (NSDictionary*)encryptyReqParam:(NSString*)tValueStr withBParams:(NSDictionary*)bParams;

- (NSDictionary*)decryptResData:(NSData*) data;

/**
 发起网络请求

 @param tValueStr  t值参数
 @param serverPath 服务器地址，debug模式下用于指定server，生产环境不生效
 @param paramDic   b参数
 @param cls        指定返回数据对应的对象
 @param block      block回调
 */
- (void)startRequestTValue:(NSString *)tValueStr
            withServerPath:(NSString *)serverPath
                 withParam:(NSMutableDictionary *)paramDic
               respondData:(Class)cls
               resultBlock:(QDNetWorkBlock)block;

@end
