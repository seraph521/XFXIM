//
//  IMLoginViewController.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMLoginViewController.h"
#import "IMMessageCenterViewController.h"
#import "IMChattingViewController.h"

@interface IMLoginViewController ()<UINavigationControllerDelegate>

@property(nonatomic,strong) UITextField * nickNameTextField;

@end

@implementation IMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏属性
    [self setupNavigationItem];
    
    //搭建UI
    [self setupUI];
    
    
}

//设置导航栏属性
- (void)setupNavigationItem
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
}

- (void)setupUI{

    self.view.backgroundColor = DreamColor(0, 78, 123);
    
    self.nickNameTextField = [[UITextField alloc] init];
    self.nickNameTextField.backgroundColor = [UIColor whiteColor];
    self.nickNameTextField.textAlignment = NSTextAlignmentCenter;
    self.nickNameTextField.textColor = DreamColor(0, 78, 123);
    [self.view addSubview:self.nickNameTextField];
    [self.nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(260);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    UILabel * label = [[UILabel alloc] init];
    label.textColor = DreamColor(250, 220, 226);
    label.text = @"请输入你的昵称";
    
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameTextField.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.nickNameTextField.mas_centerX);
    
    }];
    
    UIButton * button = [[UIButton alloc] init];
    [button setTitle:@"进入聊天" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setBackgroundColor:DreamColor(230, 28, 100)];
    [button addTarget:self action:@selector(startChat) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.nickNameTextField.mas_centerX);
        make.top.mas_equalTo(label.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    
    
}

//进入聊天界面
- (void)startChat{
    
    [self.nickNameTextField resignFirstResponder];

    if(self.nickNameTextField.text == nil || [self.nickNameTextField.text isEqualToString:@""]){
    
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }
    if ([[self.nickNameTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空格"];
        return;
    }
    
    IMMessageCenterViewController * messageCenterViewController = [[IMMessageCenterViewController alloc] init];
    
    [self.navigationController pushViewController:messageCenterViewController animated:YES];
}



#pragma mark - UINavigationControllerDelegate

- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if(viewController == self || [viewController isKindOfClass:[IMMessageCenterViewController class]] ||[viewController isKindOfClass:[IMChattingViewController class]]){
    
        [viewController.navigationController setNavigationBarHidden:YES animated:YES ];
        
    }else{
        
        [viewController.navigationController setNavigationBarHidden:NO animated:YES ];
    
    }
    
}


@end
