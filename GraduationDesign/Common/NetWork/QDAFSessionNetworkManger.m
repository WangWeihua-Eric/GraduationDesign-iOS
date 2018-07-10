//
//  QDAFSessionNetworkManger.m
//  CarDriver
//
//  Created by jinfeng.du on 16/10/28.
//  Copyright © 2016年 Qunar. All rights reserved.
//

#import "QDAFSessionNetworkManger.h"
#import <AFNetworking.h>
#import <YYModel.h>
#import "DriverDataCryption.h"
#import "QDMacro.h"

#ifdef DEBUG
    #define DebugSwitch                     (1)
#endif

@interface QDAFSessionNetworkManger()
//@property (nonatomic, strong) NSMutableDictionary *dicForConnect;         // 保存请求信息
//@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, strong) NSMutableDictionary *cParam;
@end

@implementation QDAFSessionNetworkManger

// 类生命周期相关的
//MARK:  - Life cycle (viewDidLoad ...)
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializationContent];
    }
    return self;
}

-(NSDictionary*) getCParam {
    return [self.cParam copy];
}

// 内存相关
//MARK: - Memory manager (init, dealloc ...)

// 自定义View、初始化等
//MARK:  - Custom views & init

// 公有有方法
//MARK:  - Public methods
- (NSDictionary*)encryptyReqParam:(NSString*)tValueStr withBParams:(NSDictionary*)bParams
{
    if(bParams == nil){
        NSDictionary *params = @{
                                 @"goDate": @"2018-07-28",
                                 @"depCity": @"北京",
                                 @"arrCity": @"上海"
                                 };
        return params;
    }
    return bParams;
}

- (NSDictionary*)decryptResData:(NSData*) data {
    NSString *decryptStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];//[DriverDataCryption decryptDriverData:data];
    if (StringIsNullOrEmpty(decryptStr)) {
        return nil;
    }
    
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[decryptStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:kNilOptions
                                                                     error:&error];
    
    return jsonDictionary;
}

- (void)startRequestTValue:(NSString *)tValueStr
            withServerPath:(NSString *)serverPath
                 withParam:(NSMutableDictionary *)paramDic
               respondData:(Class)cls
               resultBlock:(QDNetWorkBlock)block
{
    // 向外界开始请求状态
    if (block) {
        block(nil, EQDRequestStatusWillStart, nil, nil);
    }
    
    NSDictionary *params = [self encryptyReqParam:tValueStr withBParams:paramDic];
    
    AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
 
    NSURLSessionDataTask *dataTask = [httpSessionManager POST:serverPath
                                                        parameters:params
                                                          progress:^(NSProgress * _Nonnull uploadProgress)
                                      {
//                                          NSLog(@"f:%f, s:%@", uploadProgress.fractionCompleted, uploadProgress.localizedDescription);
                                      }success:^(NSURLSessionDataTask *task, id responseObject){
                                          NSLog(@"network success tvalue: %@", tValueStr);
                                          NSDictionary *jsonDictionary = [self decryptResData:responseObject];
                                          if (jsonDictionary) {
                                              NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc] initWithDictionary:jsonDictionary];
                                              if ([jsonDictionary objectForKey:@"data"]) {
                                                  id data = [jsonDictionary objectForKey:@"data"];
                                                  if ([data isKindOfClass:[NSDictionary class]]) {
                                                      [sourceDic addEntriesFromDictionary: data];
                                                  }else if ([data isKindOfClass:[NSArray class]]) {
                                                      if ([tValueStr isEqualToString:@"car_qb_driv_push_order_detail"]) {
                                                          [sourceDic addEntriesFromDictionary: @{@"orderListInfo": data}];
                                                      }else {
                                                          [sourceDic addEntriesFromDictionary:@{@"extralKey": data}];
                                                      }
                                                  }
                                              }
                                              
                                              QDNetResultBaseModel *baseObj = [cls yy_modelWithJSON:sourceDic];
                                              block(task, EQDRequestStatusSuccess,baseObj, baseObj.bstatus.code);
                                              
//                                              {
//                                                  //test CODE
//                                                  if ([baseObj.bstatus.code integerValue] != 0) {
//                                                      NSString *errStr = baseObj.bstatus.des;
//                                                      [JFAlertController showNotifyAlertWithMessage:[NSString stringWithFormat:@"code不等0 msg:%@ code:%@", errStr, baseObj.bstatus.code]
//                                                                                            handler:nil];
//                                                  }
//                                              }
                                          } else {
                                              block(task,  EQDRequestStatusFail, nil, nil);
                                          }
                                      } failure:^(NSURLSessionDataTask *task, NSError *error)
                                      {
                                          if (NSURLErrorCancelled == [error code]) {
                                              block(task,  EQDRequestStatusCancelled, nil, nil);
                                          }else {
                                              block(task,  EQDRequestStatusFail, nil, nil);
                                          }
                                      }];
    
    if (dataTask) {
        // 向外界传递加载状态
        if (block) {
            block(dataTask, EQDRequestStatusLoading, nil,nil);
        }
    }
    else {
        // 网络错误
        if (block) {
            block(dataTask, EQDRequestStatusFail, nil,nil);
        }
    }
    
#if DebugSwitch
    LogInfo(@"Driver Request url:%@, %@ \n ", serverPath, tValueStr);
#endif
}

// 所有的事件处理
//MARK:  - Actions

// 界面切换
// MARK: - Page Change & push eg.

// 类私有方法
//MARK:  - Private methods
+ (NSString*) driverServerPath {
#if (BETA_BUILD == 1)
    NSString *hyHostStr = [[QDGlobalInstance sharedInstance] hybridHost];
    if ([hyHostStr rangeOfString:@"dev"].location != NSNotFound) {
        return @"http://cardev.qunar.com/qb/drivui/crypt";
    }else if ([hyHostStr rangeOfString:@"beta"].location != NSNotFound) {
        return @"http://carbeta.qunar.com/qb/drivui/crypt";
    }else if ([hyHostStr rangeOfString:@"localhost"].location != NSNotFound) {
        return @"http://cardev.qunar.com/qb/drivui/crypt";
    }else {
        return @"http://car.qunar.com/qb/drivui/crypt";
    }
#else
    return @"http://car.qunar.com/qb/drivui/crypt";
#endif
}

//初始化上下文环境变量
-(void) initializationContent {
//    self.httpSessionManager = [AFHTTPSessionManager manager];
//    self.httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self initializationCParam];
}

//初始化C参数
- (void)initializationCParam
{
    
}

//数据加密
-(NSString*) encryptyStr:(NSDictionary *)paramDic {
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paramStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSString *str = paramStr;
//    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
//    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
//    {
//        //test code
//        NSString *ret = [DriverDataCryption encryptDriverString:paramStr];
//        
//        NSString *s1 = [DriverDataCryption decryptDriverData:[ret dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSLog(@"pa:%@", paramStr);
//        NSLog(@"ret:%@", ret);
//        NSLog(@"s1:%@", s1);
//    }
    
    return [DriverDataCryption encryptDriverString:paramStr];
}


// 通知回调，具体可以细分
//MARK:  - Custom Notifications

// 系统的Delegate
//MARK:  - System Delegate

// 自定义类的Delegate
//MARK:  - Custom Delegate


@end
