//
//  IMLoginUserModelArchieveTool.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMLoginUserModelArchieveTool.h"
#import "IMLoginUserModel.h"

@implementation IMLoginUserModelArchieveTool

+ (void)userInfoAchieveToFile:(IMLoginUserModel *)account{

    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) lastObject];
    NSString * filePath = [doc stringByAppendingPathComponent:@"userInfo.data"];
    [NSKeyedArchiver archiveRootObject:account toFile:filePath];
}

+ (IMLoginUserModel *)userInfoUnAchieveFromFile{

    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) lastObject];
    NSString * filePath = [doc stringByAppendingPathComponent:@"userInfo.data"];
   IMLoginUserModel * model =  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return model;
}

+ (void)removeSelfUserFromDisk{

    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [doc stringByAppendingPathComponent:@"userInfo.data"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager isDeletableFileAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

@end
