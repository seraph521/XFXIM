//
//  EvaGrowingTextView.m
//  Yoal
//
//  Created by eva on 15/11/3.
//  Copyright © 2015年 Eva. All rights reserved.
//

#import "EvaGrowingTextView.h"
#import "Masonry.h"

@interface EvaGrowingTextView ()

@property (nonatomic,assign) CGFloat currentHeight;
@property (nonatomic,assign) CGFloat textViewWidth;
@property (nonatomic,strong) UILabel * placeHolderLabel;

@end


@implementation EvaGrowingTextView

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        [self addSubview:self.placeHolderLabel];
        
        [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(5);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manualLayoutSubViews) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}


#pragma mark - 响应者方法
- (BOOL)resignFirstResponder
{
    if(self.text.length == 0){
        [self makePlaceholderLabelVisable:YES];
    }
    return [super resignFirstResponder];
}


- (void)setText:(NSString *)text
{
    [super setText:text];
    if(self.text.length == 0){
        [self makePlaceholderLabelVisable:YES];
    }
}


#pragma mark - lazy load

- (UILabel *)placeHolderLabel
{
    if(_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc]init];
        _placeHolderLabel.textColor = DreamColor(153, 153, 153);
        _placeHolderLabel.text = @"";
        _placeHolderLabel.font = [UIFont systemFontOfSize:16];
    }
    return _placeHolderLabel;
}


- (void)makePlaceholderLabelVisable:(BOOL)needShow
{
    if(needShow){
        [self addSubview:self.placeHolderLabel];
        
        [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(5);
        }];
    }else{
        [self.placeHolderLabel removeFromSuperview];
    }
}


- (void)setNeedShowPlaceholder:(BOOL)needShowPlaceholder
{
    _needShowPlaceholder = needShowPlaceholder;
    self.placeHolderLabel.hidden = !needShowPlaceholder;
}

- (void)setPlaceholderTitle:(NSString *)placeholderTitle
{
    _placeholderTitle = placeholderTitle;
    self.placeHolderLabel.text = placeholderTitle;
}

#pragma mark - 重新布局子布局
- (void)manualLayoutSubViews
{
    if([[UIDevice currentDevice].systemVersion doubleValue] < 8.0){
        [super layoutSubviews];
    }
    
    if(self.textViewWidth == 0){
        self.textViewWidth = self.bounds.size.width;
    }
    
    if(self.text.length == 0){
        [self makePlaceholderLabelVisable:YES];
    }else{
        [self makePlaceholderLabelVisable:NO];
    }
    
    CGSize sizeThatFits = [self sizeThatFits:CGSizeMake(self.textViewWidth, self.maxHeight)];
    CGFloat newHeight = sizeThatFits.height;
    
    if(newHeight != self.currentHeight && self.currentHeight != 0){
        if(newHeight <= self.maxHeight){
            if([self.delegate respondsToSelector:@selector(updateContraintsWithNewHeight:)]){
                [self.delegate updateContraintsWithNewHeight:newHeight];
            }
        }else{
            if([self.delegate respondsToSelector:@selector(updateContraintsWithNewHeight:)]){
                [self.delegate updateContraintsWithNewHeight:self.maxHeight];
                [self scrollRectToVisible:CGRectMake(0, newHeight - 5, self.textViewWidth, 5) animated:YES];
            }
        }
    }
    
    if(self.text.length == 0){
        self.currentHeight = newHeight;
    }else{
        self.currentHeight = newHeight;
    }
    
    if([[UIDevice currentDevice].systemVersion doubleValue] < 8.0){
        [self layoutSubviews];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if([[UIDevice currentDevice].systemVersion doubleValue] < 8.0){
        [self layoutIfNeeded];
    }

}



@end
