//
//  IMTextMessageCell.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMTextMessageCell.h"
#import "IMMessage.h"

#define TEXT_MAX_WIDTH [UIView lf_sizeFromIphone6:230]

@interface IMTextMessageCell ()

@property (nonatomic,weak) UILabel * contentLabel;

@property (nonatomic,strong) MASConstraint * contentLabelLeftConstraint;

@property (nonatomic,strong) MASConstraint * textLabelTopConstraint;

@end

@implementation IMTextMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        UILabel * contentLabel = [[UILabel alloc] init];
        contentLabel.userInteractionEnabled = YES;
        [contentLabel addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)]];
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.textColor = DreamColor(51, 51, 51);
        contentLabel.text = @"";
        contentLabel.numberOfLines = 0;
        [self.containView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.contentLabelLeftConstraint = make.left.equalTo(self.nickLabel);
            make.right.equalTo(self.nickLabel).priorityMedium();
            self.textLabelTopConstraint = make.top.equalTo(self.nickLabel.mas_bottom).offset([UIView lf_sizeFromIphone6:10]);
            make.top.equalTo(self.containView).priorityLow();
            make.right.equalTo(self.containView).offset(-[UIView lf_sizeFromIphone6:20]);
        }];
        
        [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentLabel).offset([UIView lf_sizeFromIphone6:10]);
        }];
    
    }
    
    return self;
}


- (void)setIsLeft:(BOOL)isLeft
{
    [super setIsLeft:isLeft];
    
    if(isLeft){
        //左侧布局
        [self.contentLabelLeftConstraint activate];
    } else {
        //右侧布局
        [self.contentLabelLeftConstraint deactivate];
    }
}

- (void)setNeedHideUserInfo:(BOOL)needHideUserInfo
{
    [super setNeedHideUserInfo:needHideUserInfo];
    
    if(needHideUserInfo){
        [self.textLabelTopConstraint deactivate];
    }else{
        [self.textLabelTopConstraint activate];
    }
}

- (void)setMessage:(IMMessage *)message{

    [super setMessage:message];
    
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] initWithString:message.content];
    [contentText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, contentText.length)];
    [contentText addAttribute:NSForegroundColorAttributeName value:DreamColor(51, 51, 51) range:NSMakeRange(0, contentText.length)];
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = [UIView lf_sizeFromIphone6:5];
    [contentText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, contentText.length)];
    
    //设置文字内容
    self.contentLabel.attributedText = contentText;
}




#pragma mark - 手势操作
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{

}

@end
