//
//  IMBaseMessageCell.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMBaseMessageCell.h"

@interface IMBaseMessageCell ()

@property (nonatomic,weak) UILabel * timeLabel;

@property (nonatomic,strong) MASConstraint * timeViewConstraint;

@property (nonatomic,strong) MASConstraint * headerButtonLeftConstraint;

@property (nonatomic,strong) MASConstraint * nickLabelLeftConstraint;

@property (nonatomic,strong) MASConstraint * headerButtonTopConstraint;

@property (nonatomic,strong) UIImage * defaultHeaderImage;

@end

@implementation IMBaseMessageCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView * containView = [[UIView alloc] init];
        [containView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBlackSpaceTaped)]];
        [self.contentView addSubview:containView];
        self.containView = containView;
        
        [containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UIView * timeView = [[UIView alloc] init];
        [containView addSubview:timeView];
        self.timeView = timeView;
        
        [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(containView);
            make.width.mas_equalTo(SCREEN_WIDTH);
            self.timeViewConstraint = make.height.mas_equalTo([UIView lf_sizeFromIphone6:25]);
            make.height.mas_equalTo(0).priorityMedium();
        }];
        
        UILabel * timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"2016-01-22 15:52";
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = DreamColor(153, 153, 153);
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [timeView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(timeView);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];

        UIButton * headerImageButton = [[UIButton alloc] init];
        [headerImageButton setBackgroundImage:[UIImage imageNamed:@"chat_header_bg"] forState:UIControlStateNormal];
        [headerImageButton setImage:self.defaultHeaderImage forState:UIControlStateNormal];
        [containView addSubview:headerImageButton];
        self.headerImageButton = headerImageButton;
        
        [headerImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            self.headerButtonTopConstraint = make.top.equalTo(timeView.mas_bottom).offset([UIView lf_sizeFromIphone6:17]);
            make.top.equalTo(timeView.mas_bottom).priorityMedium();
            make.size.mas_equalTo([UIView lf_rectSizeFromIphone6:32]);
            self.headerButtonLeftConstraint = make.left.equalTo(containView).offset([UIView lf_sizeFromIphone6:15]);
            make.right.equalTo(containView).offset(-[UIView lf_sizeFromIphone6:15]).priorityMedium();
        }];
        
        UILabel * nickLabel = [[UILabel alloc] init];
        nickLabel.font = [UIFont boldSystemFontOfSize:13];
        nickLabel.textColor = [UIColor blackColor];
        [containView addSubview:nickLabel];
        self.nickLabel = nickLabel;
        
        [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.nickLabelLeftConstraint = make.left.equalTo(headerImageButton.mas_right).offset([UIView lf_sizeFromIphone6:10]);
            make.right.equalTo(headerImageButton.mas_left).offset(-[UIView lf_sizeFromIphone6:10]).priorityMedium();
            make.centerY.equalTo(headerImageButton);
        }];
        
    }
    return self;
}

#pragma mark - lazy load
- (UIImage *)defaultHeaderImage
{
    if(_defaultHeaderImage == nil){
        _defaultHeaderImage = [UIImage scaleImage:[UIImage imageNamed:@"default_setting_header"] toSize:[UIView lf_rectSizeFromIphone6:30]];
    }
    return _defaultHeaderImage;
}

#pragma mark - 设置左侧布局
- (void)setIsLeft:(BOOL)isLeft
{
    _isLeft = isLeft;
    
    if(isLeft){
        //左侧布局
        [self.headerButtonLeftConstraint activate];
        [self.nickLabelLeftConstraint activate];
    } else {
        //右侧布局
        [self.headerButtonLeftConstraint deactivate];
        [self.nickLabelLeftConstraint deactivate];
    }
}

- (void)setNeedHideUserInfo:(BOOL)needHideUserInfo
{
    _needHideUserInfo = needHideUserInfo;
    
    self.headerImageButton.hidden = needHideUserInfo;
    self.nickLabel.hidden = needHideUserInfo;
}

#pragma mark - 设置是否显示时间
- (void)setNeedShowTime:(BOOL)needShowTime
{
    _needShowTime = needShowTime;
    
    self.timeLabel.hidden = !needShowTime;
    
    if(needShowTime){
        //需要显示时间
        [self.timeViewConstraint activate];
        [self.headerButtonTopConstraint activate];
    } else {
        //不需要显示时间
        [self.timeViewConstraint deactivate];
        [self.headerButtonTopConstraint deactivate];
    }
}

#pragma mark - 点击事件
- (void)handleBlackSpaceTaped
{
//    if([self.delegate respondsToSelector:@selector(clickedCellBlankSpaceToEndEditing)]){
//        [self.delegate clickedCellBlankSpaceToEndEditing];
//    }
}

@end
