//
//  IMUtil.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation IMUtil

#pragma mark - GCD async
+ (void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

+ (void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

+ (void)runAfterSecs:(float)secs block:(void (^)())block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), block);
}


#pragma mark - 加密相关
+ (NSString*)uuid{
    NSString *chars=@"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    assert(chars.length==62);
    int len=(int)chars.length;
    NSMutableString* result=[[NSMutableString alloc] init];
    for(int i=0;i<24;i++){
        int p=arc4random_uniform(len);
        NSRange range=NSMakeRange(p, 1);
        [result appendString:[chars substringWithRange:range]];
    }
    return result;
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - 翻转数组
+ (NSArray*)reverseArray:(NSArray*)originArray{
    NSMutableArray* array=[NSMutableArray arrayWithCapacity:[originArray count]];
    NSEnumerator* enumerator=[originArray reverseObjectEnumerator];
    for(id element in enumerator){
        [array addObject:element];
    }
    return array;
}

#pragma mark - 生成与好友的conversationId
+ (NSString *)getConversationIdWithUserId:(NSString *)userId
{
    if(userId){
        return [self md5:userId];
    }else{
        return nil;
    }
}

#pragma mark - 获取当前时间戳
+ (int64_t)getCurrentTimestamp
{
    return (((int64_t)[[NSDate date] timeIntervalSince1970]) + 10) * 1000;
}

@end
