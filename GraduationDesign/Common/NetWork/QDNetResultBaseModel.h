//
//  QDNetResultBaseModel.h
//  CarDriver
//
//  Created by jinfeng.du on 16/10/28.
//  Copyright © 2016年 Qunar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFCodingObject.h"

@interface QDNetworkAction : JFCodingObject
@property (nonatomic, strong, getter = actionPageTo) NSNumber *pageto;                                          // 标识跳转到哪个页面
@end

@interface QDSearchNetStatus : JFCodingObject
@property (nonatomic, strong, getter = returnCode) NSNumber *code;            // 返回代码
@property (nonatomic, strong, getter = returnDesc) NSString *des;             // 返回描述
@end

@interface QDSearchNetDate : JFCodingObject
@property (nonatomic, strong, getter = returnStatus) NSString *status;             // 返回描述
@property (nonatomic, strong, getter = returnName) NSString *name;             // 返回描述
@property (nonatomic, strong, getter = returnAirCode) NSString *airCode;             // 返回描述
@property (nonatomic, strong, getter = returnDepAirport) NSString *depAirport;             // 返回描述
@property (nonatomic, strong, getter = returnArrAirport) NSString *arrAirport;             // 返回描述
@property (nonatomic, strong, getter = returnDepTime) NSString *depTime;             // 返回描述
@property (nonatomic, strong, getter = returnArrTime) NSString *arrTime;             // 返回描述
@property (nonatomic, strong, getter = returnDepTerminal) NSString *depTerminal;             // 返回描述
@property (nonatomic, strong, getter = returnArrTerminal) NSString *arrTerminal;             // 返回描述
@end

@interface QDNetResultBaseModel : JFCodingObject
@property (nonatomic, strong, getter = networkStatus) QDSearchNetStatus *bstatus;
@property (nonatomic, strong, getter = networkData) NSArray *data;
@end

