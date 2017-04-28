//
//  IMSlideHeaderView.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/28.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMSlideHeaderView.h"

@interface IMSlideHeaderView ()

@property(nonatomic,strong) UIScrollView * scrollView;

@property(nonatomic,strong) UIImageView * avatarImageView;

@property(nonatomic,strong) UILabel * nicknamelabel;

@end

@implementation IMSlideHeaderView

- (instancetype) initWithFrame:(CGRect)frame{

    if(self == [super initWithFrame:frame]){
    
        self.backgroundColor = [UIColor whiteColor];
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.height.mas_offset([UIView lf_sizeFromIphone6:200]);
        }];
        
        UIImageView * imageView = [[UIImageView alloc] init];
        UIImage * bgImage = [UIImage imageNamed:@"personBG"];
        imageView.image = bgImage;
        [scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scrollView);
        }];
        scrollView.bounces = NO;
        scrollView.contentSize = bgImage.size;
        
        self.scrollView = scrollView;
        
        UIImageView * avatarImageView = [[UIImageView alloc] init];
        avatarImageView.image = [UIImage imageNamed:@"chat_header_bg"];
        avatarImageView.layer.cornerRadius = 20;
        avatarImageView.layer.masksToBounds = YES;
        [self addSubview:avatarImageView];
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([UIView lf_sizeFromIphone6:15]);
            make.bottom.mas_equalTo(scrollView.mas_bottom).offset(- [UIView lf_sizeFromIphone6:20]);
            make.size.mas_equalTo(CGSizeMake([UIView lf_sizeFromIphone6:40], [UIView lf_sizeFromIphone6:40]));
        }];
        self.avatarImageView = avatarImageView;
        
        UILabel * nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.text = @"懒羊羊";
        nicknameLabel.font = [UIFont systemFontOfSize:30];
        nicknameLabel.textColor = [UIColor whiteColor];
        [self addSubview:nicknameLabel];
        
        [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatarImageView.mas_right).offset([UIView lf_sizeFromIphone6:15]);
            make.centerY.equalTo(avatarImageView);
        }];
  
        self.translatesAutoresizingMaskIntoConstraints = YES;
    }
    return self;
}

@end
