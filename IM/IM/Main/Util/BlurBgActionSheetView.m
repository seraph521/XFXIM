//
//  BlurBgActionSheetView.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/26.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "BlurBgActionSheetView.h"

@interface BlurBgActionSheetView ()

@property (nonatomic,weak) UIImageView * blurImageView;

@property (nonatomic,weak) UIView * backShadowView;

@property (nonatomic,weak) UIView * buttonContainView;

@property (nonatomic,assign) NSInteger titleCount;

@end

@implementation BlurBgActionSheetView

- (instancetype) initWithBlurImage:(UIImage *)blurImage cancelButtonTitle:(NSString *)cancelButtonTitle otherButtontitles:(NSArray *)otherButtontitles{

    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
    
        UIImageView * bgImageView = [[UIImageView alloc] init];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.image = blurImage;
        [self addSubview:bgImageView];
        self.blurImageView = bgImageView;
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        
        //创建shadowView
        UIView * backShadowView = [[UIView alloc] init];
        backShadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        backShadowView.alpha = 0.0;
        [self addSubview:backShadowView];
        self.backShadowView = backShadowView;
        
        [backShadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
        
        [backShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        
        NSMutableArray * allButtonTitles = [NSMutableArray array];
        [allButtonTitles addObjectsFromArray:otherButtontitles];
        [allButtonTitles addObject:cancelButtonTitle];
        
        self.titleCount = allButtonTitles.count;
        
        UIView * buttonContainView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, [UIView lf_sizeFromIphone6:50] * allButtonTitles.count)];
        [self addSubview:buttonContainView];
        self.buttonContainView = buttonContainView;
        
        //创建其他按钮
        for (int i = 0;i < allButtonTitles.count;i++) {
            NSString * otherTitle = allButtonTitles[i];
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, (i == allButtonTitles.count - 1)?([UIView lf_sizeFromIphone6:50] * i + [UIView lf_sizeFromIphone6:10]):[UIView lf_sizeFromIphone6:50] * i, SCREEN_WIDTH, [UIView lf_sizeFromIphone6:50])];
            [button setTitle:otherTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonContainView addSubview:button];
            
            if(i != allButtonTitles.count - 1){
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake([UIView lf_sizeFromIphone6:15],button.height - 0.5, SCREEN_WIDTH - [UIView lf_sizeFromIphone6:30], 0.5)];
                lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:(i == allButtonTitles.count - 2)?0.4:0.1];
                [button addSubview:lineView];
            }
            
            button.tag = i;
        }
        
    }
    
    return self;
    
}

- (void)handleButtonClick:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(actionSheetView:clickButtonAtIndex:)]){
        [self.delegate actionSheetView:self clickButtonAtIndex:button.tag];
    }
    
    [self hide];
}

- (void) show{

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backShadowView.alpha = 1.0;
        self.buttonContainView.y = SCREEN_HEIGHT - [UIView lf_sizeFromIphone6:50] * self.titleCount;
    }];
    
}

- (void) hide{

    [UIView animateWithDuration:0.3 animations:^{
        self.backShadowView.alpha = 0.0;
        self.buttonContainView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
