//
//  IMChattingViewController.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMConversation.h"

@interface IMChattingViewController : UIViewController

@property (nonatomic,weak) UITableView * messageTableView;

@property (nonatomic,strong) IMConversation * conversation;

@end
