//
//  IMLoginUserModelArchieveTool.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMLoginUserModel.h"

@interface IMLoginUserModelArchieveTool : NSObject

+ (void)userInfoAchieveToFile:(IMLoginUserModel *)account;

+ (IMLoginUserModel *)userInfoUnAchieveFromFile;

+ (void)removeSelfUserFromDisk;


@end
