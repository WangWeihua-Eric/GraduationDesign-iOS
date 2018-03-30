//
//  JFCodingObject.m
//  CarDriver
//
//  Created by jinfeng.du on 16/11/2.
//  Copyright © 2016年 Qunar. All rights reserved.
//

#import "JFCodingObject.h"
#import <objc/runtime.h>

@implementation JFCodingObject

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self encodeWithCoder:aCoder withClass:[self class]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        [self initWithCoder:aDecoder withClass:[self class]];
    }
    return self;
    
}

- (id)copyWithZone:(nullable NSZone *)zone {
    
    if (self == [NSObject class]) {
        return self;
    }
    
    id copySelf = [[[self class] alloc] init];
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [copySelf setValue:[value copy] forKey:key];
    }
    
    free(ivars);
    
    //暂时未处理父类的迭代
    
    return copySelf;
}

#pragma mark - private method
- (void)encodeWithCoder:(NSCoder *)aCoder withClass:(Class)cls
{
    if (cls == [NSObject class]) {
        return;
    }
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    
    free(ivars);
    
    
    Class supCls = class_getSuperclass(cls);
    [self encodeWithCoder:aCoder withClass:supCls];
}

- (void)initWithCoder:(NSCoder *)aDecoder withClass:(Class)cls
{
    if (cls == [NSObject class]) {
        return;
    }
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [aDecoder decodeObjectForKey:key];
        
        // 设置到成员变量身上
        if(value != nil)
            [self setValue:value forKey:key];
    }
    
    free(ivars);
    
    Class supCls = class_getSuperclass(cls);
    [self initWithCoder:aDecoder withClass:supCls];
}

@end
