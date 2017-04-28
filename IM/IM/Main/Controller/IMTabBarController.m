//
//  IMTabBarController.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/28.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMTabBarController.h"
#import "IMMessageCenterViewController.h"
#import "IMNavigationController.h"
#import "IMContactsViewController.h"
#import "IMZoneViewController.h"
#import "IMSlideViewController.h"

#define MAX_SLIDE_WIDTH SCREEN_WIDTH * 0.8

@interface IMTabBarController (){

    CGPoint touchStartPoint;
}

@property(nonatomic,strong) UIView * slideView;

@property(nonatomic,strong) UIView * mainView;

@property(nonatomic,strong) UIView * tabBarView;

@property(nonatomic,strong) UIView * shadowView;

@end

@implementation IMTabBarController

//只执行一次，设置TabBarItem 颜色，字体等
+ (void)load{

    UITabBarItem * tabbarItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    //颜色
    NSMutableDictionary * colorDic = [NSMutableDictionary dictionary];
    colorDic[NSForegroundColorAttributeName] = DreamColor(38, 171, 40);
    //字体
    NSMutableDictionary * fontDic = [NSMutableDictionary dictionary];
    fontDic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [tabbarItem setTitleTextAttributes:colorDic forState:UIControlStateSelected];
    [tabbarItem setTitleTextAttributes:fontDic forState:UIControlStateNormal];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildController];
    
    [self setupTabBar];
    
    [self setupSlideView];
}

- (void)setupSlideView{
    
    
   // self.mainView = self.view.subviews[0];
   // self.tabBarView = self.view.subviews[1];
    
    
    self.mainView = [[UIView alloc] init];
    self.mainView.frame = self.view.bounds;
    [self.view addSubview:self.mainView];
    
    UIView * subView0 = self.view.subviews[0];
    UIView * subView1 = self.view.subviews[1];
    
    [self.mainView addSubview:subView0];
    [self.mainView addSubview:subView1];
    
    
    
    //侧滑界面
    IMSlideViewController * slideViewController = [[IMSlideViewController alloc] init];
    
    UIView * slideView = slideViewController.view;
    slideView.frame = CGRectMake(-MAX_SLIDE_WIDTH, 0, MAX_SLIDE_WIDTH , SCREEN_HEIGHT);
    self.slideView = slideView;
    [self.view addSubview:slideView];
    
    //主界面遮罩
    
    UIView * shadowView = [[UIView alloc] init];
    shadowView.frame = self.view.frame;
    shadowView.alpha = 0;
    shadowView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha:0.5];
    self.shadowView = shadowView;
    [self.mainView addSubview:shadowView];
    
    //点按手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    [shadowView addGestureRecognizer:tapGesture];

    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
}


#pragma mark - 遮罩点按手势
- (void)handleTapGesture{

    [UIView animateWithDuration:0.20 animations:^{
        //关闭
        self.slideView.x = -MAX_SLIDE_WIDTH;
        self.mainView.x = 0;
        self.shadowView.alpha = 0;
    }];
    
}

#pragma mark - 滑动手势处理
- (void)handlePanGesture:(UIPanGestureRecognizer *) recognizer {

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            touchStartPoint = [recognizer locationInView:self.view];
        }
            break;
        case UIGestureRecognizerStateChanged :
        {
            CGPoint currentPoint = [recognizer locationInView:self.view];
            CGFloat xOffSet = currentPoint.x - touchStartPoint.x;
            touchStartPoint = currentPoint;
            
            if(self.slideView.x + xOffSet >= -MAX_SLIDE_WIDTH && self.slideView.x + xOffSet <= 0){
            
                self.slideView.x += xOffSet;
                self.mainView.x += xOffSet;
                self.shadowView.alpha = (MAX_SLIDE_WIDTH - fabs(self.slideView.x)) / MAX_SLIDE_WIDTH ;
            }
           
            
        }
            break;
            
        default:
        {
        
            if(MAX_SLIDE_WIDTH - fabs(self.slideView.x) > MAX_SLIDE_WIDTH * 0.5){
            
                [UIView animateWithDuration:0.20 animations:^{
                    //打开
                    self.slideView.x = 0;
                    self.mainView.x = MAX_SLIDE_WIDTH;
                    self.shadowView.alpha = 1;
                }];
            }else{
                [UIView animateWithDuration:0.20 animations:^{
                    //关闭
                    self.slideView.x = -MAX_SLIDE_WIDTH;
                    self.mainView.x = 0;
                    self.shadowView.alpha = 0;
                }];
              
            }
        }
            break;
    }
}





- (void)setupChildController{

    IMMessageCenterViewController * messageCenterVc = [[IMMessageCenterViewController alloc] init];
    IMNavigationController * nav1 = [[IMNavigationController alloc] initWithRootViewController:messageCenterVc];
    
    IMContactsViewController * contactsVc = [[IMContactsViewController alloc] init];
    IMNavigationController * nav2 = [[IMNavigationController alloc] initWithRootViewController:contactsVc];
    
    IMZoneViewController * zoneVc = [[IMZoneViewController alloc] init];
    IMNavigationController * nav3 = [[IMNavigationController alloc] initWithRootViewController:zoneVc];
    
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:nav3];
    
}

- (void)setupTabBar{
    
    IMNavigationController * nav0 = self.childViewControllers[0];
    nav0.tabBarItem.title = @"聊聊";
    nav0.tabBarItem.image = [UIImage imageNamed:@"tabbar_message_normal"];
    nav0.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabbar_message_selected"];
    
    IMNavigationController * nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"朋友";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabbar_contacts_normal"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabbar_contacts_selected"];
    
    IMNavigationController * nav2 = self.childViewControllers[2];
    nav2.tabBarItem.title = @"动态";
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabbar_zone_normal"];
    nav2.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabbar_zone_selected"];

}


@end
