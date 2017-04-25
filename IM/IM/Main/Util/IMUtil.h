//
//  IMUtil.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMUtil : NSObject

#pragma mark - GCD async
+ (void)runInGlobalQueue:(void (^)())queue;
+ (void)runInMainQueue:(void (^)())queue;
+ (void)runAfterSecs:(float)secs block:(void (^)())block;

#pragma mark - 加密相关
+ (NSString *)uuid;
+ (NSString *)md5:(NSString *)str;
#pragma mark - 翻转数组
+ (NSArray*)reverseArray:(NSArray*)originArray;

#pragma mark - 生成与好友的conversationId
+ (NSString *)getConversationIdWithUserId:(NSString *)userId;

#pragma mark - 获取当前时间戳
+ (int64_t)getCurrentTimestamp;

@end
