//
//  AppDelegate.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "IMLoginViewController.h"
#import"IMNavigationController.h"
#import "IMLoginUserModel.h"   
#import "IMLoginUserModelArchieveTool.h"
#import "IMManager.h"
#import "IMCoreDataStack.h"

#define APP_ID   @"qXhjKySMV4NVFU04dL7x4yQW-gzGzoHsz"
#define APP_KEY  @"eYLez0YSFraK26DH1yXw3V1Y"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    IMLoginViewController * loginViewController = [[IMLoginViewController alloc] init];
    IMNavigationController * navigationController = [[IMNavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    
    [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY];
    
    IMLoginUserModel * userModel = [IMLoginUserModelArchieveTool userInfoUnAchieveFromFile];
    if(!userModel){
    
        IMLoginUserModel * user = [[IMLoginUserModel alloc] init];
        user.uname = @"小懒";
        user.uid = 321;
//        user.uname = @"懒羊羊";
//        user.uid = 123;
        [IMLoginUserModelArchieveTool userInfoAchieveToFile:user];
    }
    //开启IM服务
    [[IMManager sharedInstance] startIMClient];
    //初始化 CoraData
    [[IMCoreDataStack sharedInstance] initCoreDataComponents];
    return YES;
}




@end
