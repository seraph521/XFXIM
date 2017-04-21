//
//  IMUtil.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMUtil : NSObject

#pragma mark - 加密相关
+ (NSString *)uuid;
+ (NSString *)md5:(NSString *)str;

@end
