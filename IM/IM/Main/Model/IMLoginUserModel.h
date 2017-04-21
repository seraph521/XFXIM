//
//  IMLoginUserModel.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMLoginUserModel : NSObject<NSCoding>

@property (nonatomic,assign) int32_t uid;

@property (nonatomic,copy) NSString * uname;

@property (nonatomic,copy) NSString * avatar;


@end
