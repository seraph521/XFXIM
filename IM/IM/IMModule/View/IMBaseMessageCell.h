//
//  IMBaseMessageCell.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMBaseMessageCell : UITableViewCell

@property (nonatomic,weak) UILabel * nickLabel;

@property (nonatomic,weak) UIButton * headerImageButton;

@property (nonatomic,weak) UIView * timeView;

@property (nonatomic,weak) UIView * containView;

@property (nonatomic,assign) BOOL isLeft;

@property (nonatomic,assign) BOOL needShowTime;

@property (nonatomic,assign) BOOL needHideUserInfo;

@property (nonatomic,strong) IMMessage * message;

@property (nonatomic,strong) NSIndexPath * indexPath;

@end
