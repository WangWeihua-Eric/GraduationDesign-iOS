//
//  NSDate+CGXPicker.h
//  CGXPickerView
//
//  Created by 王维华 on 2017/8/22.
//  Copyright © 2017年 王维华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CGXPicker)
/** 获取当前的时间 */
+ (NSString *)currentDateString;
#pragma mark - 按指定格式获取当前的时间
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr;
@end
