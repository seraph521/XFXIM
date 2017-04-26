//
//  EvaDateUtil.h
//  Yoal
//
//  Created by eva on 15/11/12.
//  Copyright © 2015年 Eva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaDateUtil : NSObject

+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate second:(NSDate *)secondDate;

+ (BOOL)twoDateIsSameYear:(NSDate *)fistDate second:(NSDate *)secondDate;

+ (BOOL)isDateYesterday:(NSDate *)date;

+ (BOOL)isDateToday:(NSDate *)date;

@end
