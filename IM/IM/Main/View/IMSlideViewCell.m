//
//  IMSlideViewCell.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/28.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMSlideViewCell.h"

@interface IMSlideViewCell()

@property (nonatomic,strong) UIImageView * iconImageView;

@property(nonatomic,strong) UILabel * titleLabel;

@end

@implementation IMSlideViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    
        UIView * contantView = [[UIView alloc] init];
        contantView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contantView];
        
        [contantView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.mas_equalTo([UIView lf_sizeFromIphone6:60]);
        }];
        
        UIImageView * iconImageView = [[UIImageView alloc] init];
        [contantView addSubview:iconImageView];
        iconImageView.image = [UIImage imageNamed:@"chat_header_bg"];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([UIView lf_sizeFromIphone6:20]);
            make.centerY.equalTo(contantView);
            make.size.mas_equalTo(CGSizeMake([UIView lf_sizeFromIphone6:30], [UIView lf_sizeFromIphone6:30]));
        }];
        self.iconImageView = iconImageView;
        
        UILabel * nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.font = [UIFont systemFontOfSize:12];
        nicknameLabel.textColor = DreamColor(51, 51, 51);
        nicknameLabel.text =  @"设置";
        [contantView addSubview:nicknameLabel];
        [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImageView.mas_right).offset([UIView lf_sizeFromIphone6:20]);
            make.centerY.equalTo(iconImageView);
        }];
        self.titleLabel = nicknameLabel;
        
    }
    return self;
}

- (void)setModel:(IMSlideModel *)model{

    _model = model;
    self.iconImageView.image = [UIImage imageNamed:model.iconName];
    self.titleLabel.text  = model.title;
}

@end
