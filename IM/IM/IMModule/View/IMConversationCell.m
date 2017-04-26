//
//  IMMessageCenterCell.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/26.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMConversationCell.h"
#import "IMConversation.h"


@interface IMConversationCell (){

    CGFloat initOffset;
    CGFloat moreFunctionButtonWidth;
}

@property (nonatomic,strong) UIImageView * avatarImageView;

@property (nonatomic,strong) UILabel * nickNameLabel;

@property (nonatomic,strong) UILabel * dateLabel;

@property (nonatomic,strong) UILabel * lastMessageLabel;

@property (nonatomic,strong) UIView * dragView;

@property (nonatomic,weak) UIButton * moreFunctionButton;

@end

@implementation IMConversationCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    
        self.backgroundColor = [UIColor clearColor];
        
        UIView * selectView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        selectView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        self.selectedBackgroundView = selectView;
        
         [self.contentView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragViewPan:)]];
        
        
        UIView * dragView = [[UIView alloc] init];
        dragView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.contentView.frame.size.height);
        [self.contentView addSubview:dragView];
        self.dragView = dragView;
        
        UIButton * moreFunctionButton = [[UIButton alloc] init];
        moreFunctionButton.alpha = 0.0;
        [moreFunctionButton setImage:[UIImage imageNamed:@"more_function_icon"] forState:UIControlStateNormal];
        [moreFunctionButton addTarget:self action:@selector(handleMoreFunctionButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreFunctionButton];
        self.moreFunctionButton = moreFunctionButton;
        
        [moreFunctionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-[UIView lf_sizeFromIphone6:7]);
            make.centerY.equalTo(dragView);
        }];
        
        moreFunctionButtonWidth = [UIImage imageNamed:@"more_function_icon"].size.width + [UIView lf_sizeFromIphone6:14];
        
        UIImageView * avatarImageView = [[UIImageView alloc] init];
        [dragView addSubview:avatarImageView];
        
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(dragView.mas_centerY);
            make.left.mas_equalTo(dragView.mas_left).offset([UIView lf_sizeFromIphone6:10]);
            make.size.mas_equalTo(CGSizeMake([UIView lf_sizeFromIphone6:40], [UIView lf_sizeFromIphone6:40]));
        }];
        self.avatarImageView = avatarImageView;
        
        self.avatarImageView.backgroundColor = [UIColor redColor];
        
        UILabel * nickNameLabel = [[UILabel alloc] init];
        nickNameLabel.font = [UIFont systemFontOfSize:14];
        nickNameLabel.textColor = [UIColor blackColor];
        [dragView addSubview:nickNameLabel];
        
        [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(avatarImageView.mas_right).offset([UIView lf_sizeFromIphone6:10]);
            make.bottom.mas_equalTo(avatarImageView.mas_centerY).offset(-[UIView lf_sizeFromIphone6:4]);
        }];
        self.nickNameLabel = nickNameLabel;
        
        UILabel * dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = DreamColor(200, 200, 200);
        dateLabel.font = [UIFont systemFontOfSize:10];
        [dragView addSubview:dateLabel];
        
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(dragView.mas_right).offset(-[UIView lf_sizeFromIphone6:20]);
            make.top.mas_equalTo(avatarImageView.mas_top);
        }];
        self.dateLabel = dateLabel;
        
        UILabel * lastMessageLabel = [[UILabel alloc] init];
        lastMessageLabel.textColor = DreamColor(200, 200, 200);
        lastMessageLabel.font = [UIFont systemFontOfSize:12];
        [dragView addSubview:lastMessageLabel];
        
        [lastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(nickNameLabel.mas_left);
            make.top.mas_equalTo(dragView.mas_centerY).offset([UIView lf_sizeFromIphone6:4]);
        }];
        
        self.lastMessageLabel = lastMessageLabel;
        

    }
    return self;
}

- (void)setConversation:(IMConversation *)conversation{

    _conversation = conversation;
    self.lastMessageLabel.text = conversation.lastMessageContent;
    self.nickNameLabel.text = conversation.user.nickname;
    self.dateLabel.text = @"刚刚";

}

- (void)handleDragViewPan:(UIPanGestureRecognizer *) recognizer{

   CGFloat offset = [recognizer locationInView:recognizer.view].x;
   CGFloat deltaOffset = offset - initOffset;
    
    BOOL panLeft = deltaOffset < 0;
    
    //根据滑动距离dragView应该是展开还是关闭
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
          initOffset = [recognizer locationInView:recognizer.view].x;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if(!panLeft && (self.dragView.x + deltaOffset > 0)){
                return;
            }
            if(panLeft){
                self.dragView.x -= -deltaOffset;
            }else{
                self.dragView.x += deltaOffset;
            }
            CGFloat alpha = fabs(self.dragView.x / moreFunctionButtonWidth);
            self.moreFunctionButton.alpha = alpha;
            
            initOffset = [recognizer locationInView:recognizer.view].x;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if(fabs(self.dragView.x) > moreFunctionButtonWidth * 0.5){
                [UIView animateWithDuration:0.2 animations:^{
                    self.dragView.x = - moreFunctionButtonWidth;
                    self.moreFunctionButton.alpha = 1.0;
                }];
                
                [self handleMoreFunctionButtonEvent];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    self.dragView.x = 0;
                    self.moreFunctionButton.alpha = 0.0;
                }];
            }

        }
            break;
        case UIGestureRecognizerStateFailed:
        {
            if(fabs(self.dragView.x) > moreFunctionButtonWidth * 0.5){
                [UIView animateWithDuration:0.2 animations:^{
                    self.dragView.x = - moreFunctionButtonWidth;
                    self.moreFunctionButton.alpha = 1.0;
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    self.dragView.x = 0;
                    self.moreFunctionButton.alpha = 0.0;
                }];
            }

        }
            break;
            
        default:
            break;
    }
}

- (void)handleMoreFunctionButtonEvent{

    [UIView animateWithDuration:0.2 animations:^{
        self.dragView.x = 0;
        self.moreFunctionButton.alpha = 0.0;
    }];
    if([self.delegate respondsToSelector:@selector(conversationCellClickedMoreFunctionButtonWithConversationAtIndexPath:)]){
        
        [self.delegate conversationCellClickedMoreFunctionButtonWithConversationAtIndexPath:self.indexPath];
    }
    
}



@end
