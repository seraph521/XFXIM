//
//  EvaDateUtil.m
//  Yoal
//
//  Created by eva on 15/11/12.
//  Copyright © 2015年 Eva. All rights reserved.
//

#import "EvaDateUtil.h"

@implementation EvaDateUtil

+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate second:(NSDate *)secondDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay;
    
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate];
    NSDateComponents *secondComponets = [calendar components:unit fromDate:secondDate];
    
    if ([fistComponets day] == [secondComponets day]
        && [fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    
    return NO;
}


+ (BOOL)isDateYesterday:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay;
    NSDateComponents * firstComponets = [calendar components:unit fromDate:date];
    NSDateComponents * currentComponents = [calendar components:unit fromDate:[NSDate date]];
    if ([firstComponets month] == [currentComponents month]
        && [firstComponets year] == [currentComponents year] && (([currentComponents day] - [firstComponets day]) == 1))
    {
        return YES;
    }
    return NO;
}

+ (BOOL)twoDateIsSameYear:(NSDate *)fistDate second:(NSDate *)secondDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate];
    NSDateComponents *secondComponets = [calendar components:unit fromDate:secondDate];
    
    if ([fistComponets year] == [secondComponets year]){
        return YES;
    }
    
    return NO;
}


+ (BOOL)isDateToday:(NSDate *)date
{
    return [self twoDateIsSameDay:[NSDate date] second:date];
}


@end
