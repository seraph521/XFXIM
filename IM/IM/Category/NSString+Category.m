//
//  NSString+Category.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/26.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "NSString+Category.h"
#import "EvaDateUtil.h"

@implementation NSString (Category)

+ (NSString *)getChatTimeString:(int64_t)timeStamp{

    NSDate * messageDate = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000];
    NSDate * currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    BOOL isSameDay = [EvaDateUtil twoDateIsSameDay:messageDate second:currentDate];
    
    //    BOOL isMessageYesterDay = [EvaDateUtil isDateYesterday:messageDate];
    if(isSameDay){
        dateFormatter.dateFormat = @"HH:mm";
        return [dateFormatter stringFromDate:messageDate];
    }else if([EvaDateUtil twoDateIsSameYear:messageDate second:currentDate]){
        dateFormatter.dateFormat = @"MM月dd日";
        NSString * resultStr = @"";
        //插入月份
        resultStr = [resultStr stringByAppendingString:[dateFormatter stringFromDate:messageDate]];
        //插入星期几
        NSCalendar * calendar = [NSCalendar currentCalendar];
        NSDateComponents * components = [calendar components:NSCalendarUnitWeekday fromDate:messageDate];
        NSArray * dayArray = @[@" 星期日 ",@" 星期一 ",@" 星期二 ",@" 星期三 ",@" 星期四 ",@" 星期五 ",@" 星期六 "];
        NSInteger weakDay = components.weekday;
        resultStr = [resultStr stringByAppendingString:dayArray[weakDay - 1]];
        //插入时间点
        dateFormatter.dateFormat = @"HH:mm";
        resultStr = [resultStr stringByAppendingString:[dateFormatter stringFromDate:messageDate]];
        
        return resultStr;
    }else{
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        return [dateFormatter stringFromDate:messageDate];
    }

}

- (BOOL)isNotEmpty
{
    return (self && ![self isKindOfClass:[NSNull class]] && ![self isEqualToString:@""]);
}

@end
