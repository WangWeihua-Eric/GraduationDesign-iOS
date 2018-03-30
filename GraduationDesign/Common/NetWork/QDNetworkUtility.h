//
//  QDNetworkUtility.h
//  CarDriver
//
//  Created by jinfeng.du on 16/10/28.
//  Copyright © 2016年 Qunar. All rights reserved.
//

#ifndef QDNetworkUtility_h
#define QDNetworkUtility_h

// 网络请求的状态
typedef NS_ENUM(NSInteger, EQDRequestStatus) {
    EQDRequestStatusWillStart,      // 即将开始
    EQDRequestStatusLoading,        // 加载中
    EQDRequestStatusSuccess,        // 请求成功
    EQDRequestStatusFail,           // 请求失败：网络失败
    EQDRequestStatusCache,          // 缓存
    EQDRequestStatusCancelled       // 取消
};

//typedef void(^QDNetWorkBlock)(EQDRequestStatus status, id data, NSNumber *returnCode, NSString* connectKey);
typedef void(^QDNetWorkBlock)(NSURLSessionDataTask *task, EQDRequestStatus status, id data, NSNumber *returnCode);

#endif /* QDNetworkUtility_h */
