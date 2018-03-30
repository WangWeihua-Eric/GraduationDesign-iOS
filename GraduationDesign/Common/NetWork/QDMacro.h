//
//  QDMacro.h
//  CarDriver
//
//  Created by jinfeng.du on 16/10/27.
//  Copyright © 2016年 Qunar. All rights reserved.
//

#ifndef QDMacro_h
#define QDMacro_h

//log类型
#define LOG_FLAG_ERROR    (1 << 0)  // 0...0001
#define LOG_FLAG_WARN     (1 << 1)  // 0...0010
#define LOG_FLAG_INFO     (1 << 2)  // 0...0100

#define LOG_LEVEL_OFF     0
#define LOG_LEVEL_ERROR   (LOG_FLAG_ERROR)                                                    // 0...0001
#define LOG_LEVEL_WARN    (LOG_FLAG_ERROR | LOG_FLAG_WARN)                                    // 0...0011
#define LOG_LEVEL_INFO    (LOG_FLAG_ERROR | LOG_FLAG_WARN | LOG_FLAG_INFO)                    // 0...0111

/**
 *  模块Log关闭开关 （此工具类如果提至CommonFramework子项目时需要使用）
 *
 *  需要在对应的子模块中添加对应的重载，比如car子模块在CarDebug.h中添加：
 #if LOG_QUNAR_PROJ_CAR_OFF
 #define LogError(frmt, ...) do { } while (0)
 #define LogWarn(frmt, ...) do { } while (0)
 #define LogInfo(frmt, ...) do { } while (0)
 #endif
 */
//#define LOG_QUNAR_PROJ_COMMON_FRAMEWORK_OFF     (0)
//#define LOG_QUNAR_PROJ_CAR_OFF                  (0)

//level
/*
 LOG_LEVEL_INFO
 LOG_LEVEL_WARN
 LOG_LEVEL_ERROR
 LOG_LEVEL_OFF
 */
// 使用 LogError LogWarn LogInfo 进行调试输出。
// 控制打印LOG的等级，可选项为上面四个；关掉LOG，则为LOG_LEVEL_OFF
#define WCLogLevel  LOG_LEVEL_INFO


#define LogError(frmt, ...)     LogObj(WCLogLevel, LOG_FLAG_ERROR, (@"[ERROR]"), frmt,  ##__VA_ARGS__)
#define LogWarn(frmt, ...)      LogObj(WCLogLevel, LOG_FLAG_WARN, (@"[WARN]"), frmt,  ##__VA_ARGS__)
#define LogInfo(frmt, ...)      LogObj(WCLogLevel, LOG_FLAG_INFO, (@"[INFO]"), frmt,  ##__VA_ARGS__)

#if (WCLogLevel &  LOG_LEVEL_INFO)
    #define LogTrace()  NSLog(@"<[TRACE] %s, Line: %d> ", __PRETTY_FUNCTION__, __LINE__);
#elif
    #define LogTrace()  do { } while (0)
#endif

#define LogPostData(postData,stringLength) {\
NSString *logString = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];\
if(logString.length>stringLength){\
logString = [logString substringToIndex:stringLength];\
}\
LogInfo(@">>>>>>>>>>request-post<<<<<<<<\n%@\n",logString);\
}

#define LogResponseString(responseString,stringLength){\
NSString *logString = responseString;\
if(logString.length>stringLength){\
logString = [responseString substringToIndex:stringLength];\
}\
LogInfo(@">>>>>>>>>>response<<<<<<<<<\n%@\n",logString);\
}


#define LogSQLString(sqlString){\
LogInfo(@">>>>>>>>>>exec sql<<<<<<<<<\n%@\n",sqlString);\
}

//Note：遵循以往约定，只有Debug模式下才允许输出log
#if (DEBUG==1)
    #define LogObj(lvl, flg, typeName, frmt, ...) \
    do { if(lvl & flg) NSLog((@"<%@ %s> " frmt), typeName, __PRETTY_FUNCTION__, ##__VA_ARGS__); } while(0)
#else
    #define LogObj(lvl, flg, typeName, frmt, ...) do { } while (0)
#endif

#define THIS_METHOD     NSStringFromSelector(_cmd)
#define THIS_FILE_NAME  NSStringFromClass([self class]) //[NSString stringWithUTF8String:__FILE__]
#define THIS_LINE       [NSString stringWithFormat:@"%d",__LINE__]

//eg: <[ERROR] -[RTaxiMiddleViewVC goSelfDriveVC]>:tttt



#define EMPTY_STRING        @""

#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// UIConstants provides contants variables for UI control.
#define UI_NAVIGATION_BAR_HEIGHT    44
#define UI_TAB_BAR_HEIGHT           49
#define UI_STATUS_BAR_HEIGHT        20
#define UI_SCREEN_WIDTH             ([[UIScreen mainScreen] bounds].size.weight)
#define UI_SCREEN_HEIGHT            ([[UIScreen mainScreen] bounds].size.height)

#define UI_LABEL_LENGTH             200
#define UI_LABEL_HEIGHT             15
#define UI_LABEL_FONT_SIZE          12
#define UI_LABEL_FONT               [UIFont systemFontOfSize:UI_LABEL_FONT_SIZE]



/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*
 Usage sample:
 
 if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
 ...
 }
 
 if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
 ...
 }
 
 */

//判断字符串是否为空或者为空字符串
#define StringIsNullOrEmpty(str) (str==nil || [(str) isEqual:[NSNull null]] ||[str isEqualToString:@""])
//判断字符串不为空并且不为空字符串
#define StringNotNullAndEmpty(str) (str!=nil && ![(str) isEqual:[NSNull null]] &&![str isEqualToString:@""])


#define kMyJobHyVCName              @"QMyJobHyViewController"
#define kDriverServerMapVCName      @"QDriverServerMapViewController"
#define kWaitingPayVCName           @"QDWaitingPayViewController"
#define kMailVCName                 @"QMailViewController"
#define kChangeOrderViewController  @"QDChangeOrderViewController"
#define kHallHyVCName               @"QOrderHallHyViewController"



#define __CSF_SINGLETON_DECLARE(TypeName) +(TypeName*) sharedInstance;
#if __has_feature(objc_arc) // ARC
    #define __CSF_SINGLETON_DEFINE(TypeName) static TypeName* static_instance;\
    +(instancetype)sharedInstance \
    { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    static_instance = [[self alloc] init];\
    }); \
    return static_instance; \
    } \
    +(id)allocWithZone:(NSZone *)zone \
    { \
    if (static_instance == nil) { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    static_instance = [super allocWithZone:zone]; \
    }); \
    } \
    return static_instance; \
    } \
    \
    -(id)copyWithZone:(NSZone *)zone \
    { \
    return static_instance; \
    } \
    \
    -(id)mutableCopyWithZone:(NSZone *)zone \
    { \
    return static_instance;\
    }

#else // 非ARC

    #define __CSF_SINGLETON_DEFINE(TypeName) static TypeName* static_instance;\
    +(TypeName*) sharedInstance {\
    @synchronized(self) {\
    if (static_instance == nil) {\
    static_instance = [[TypeName alloc] init];\
    }\
    }\
    return static_instance;\
    }\
    + (id)allocWithZone:(NSZone *)zone\
    {\
    @synchronized(self) {\
    if (static_instance == nil) {\
    static_instance = [super allocWithZone:zone];\
    }\
    }\
    return static_instance;\
    }\
    - (id)copyWithZone:(NSZone *)zone {\
    return self;\
    }\
    - (id)retain {\
    return self;\
    }\
    - (NSUInteger)retainCount {\
    return UINT_MAX;\
    }\
    - (_ONE_WAY void)release {\
    }\
    - (id)autorelease {\
    return self;\
    }

#endif



#endif /* QDMacro_h */
