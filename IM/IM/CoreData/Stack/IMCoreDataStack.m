//
//  IMCoreDataStack.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMCoreDataStack.h"

static IMCoreDataStack * stack;

@implementation IMCoreDataStack

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack = [super allocWithZone:zone];
        [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelError];
    });
    return stack;
}

+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

- (id)copy
{
    return [[[self class] alloc] init];
}

#pragma mark - 初始化CoreData组件
- (void)initCoreDataComponents
{
    [MagicalRecord cleanUp];
    
    //初始化底层sqlite store加入协调器中
    IMLoginUserModel * loginUserModel = [IMLoginUserModelArchieveTool userInfoUnAchieveFromFile];
    
    NSURL * storeUrl;
    if(loginUserModel){
        storeUrl = [[NSURL fileURLWithPath:DocumentsPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"user_%zd/XFXIM.sqlite",loginUserModel.uid]];
        NSLog(@"====storeUrl=%@",storeUrl);
    }else{
        storeUrl = [[NSURL fileURLWithPath:DocumentsPath] URLByAppendingPathComponent:@"no_login_user/XFXIM.sqlite"];
    }
    
    if(storeUrl){
        //初始化CoreDataStack
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:storeUrl];
    }
}

- (void)resetCoreDataComponents
{
    //清理CoreData链接
    [MagicalRecord cleanUp];
}
@end
