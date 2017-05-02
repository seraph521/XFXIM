//
//  IMContactsCell.m
//  IM
//
//  Created by LT-MacbookPro on 17/5/2.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMContactsCell.h"

@interface IMContactsCell()

@property(nonatomic,strong) UIImageView * avatarImageView;

@property(nonatomic,strong) UILabel * nicknameLabel;

@end




@implementation IMContactsCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    
        self.backgroundColor = [UIColor clearColor];
        UIView * containView = [[UIView alloc] init];
        [self.contentView addSubview:containView];
        
        [containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UIImageView * avatarImageView = [[UIImageView alloc] init];
        avatarImageView.layer.cornerRadius = [UIView lf_sizeFromIphone6:20];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.backgroundColor = [UIColor orangeColor];
        [containView addSubview:avatarImageView];
        
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo([UIView lf_sizeFromIphone6:20]);
            make.centerY.equalTo(containView);
            make.size.mas_equalTo(CGSizeMake([UIView lf_sizeFromIphone6:40], [UIView lf_sizeFromIphone6:40]));
        }];
        self.avatarImageView = avatarImageView;
        
        UILabel * nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.font = [UIFont systemFontOfSize:14];
        nicknameLabel.textColor = [UIColor blackColor];
        [containView addSubview:nicknameLabel];
        [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatarImageView.mas_right).offset([UIView lf_sizeFromIphone6:10]);
            make.centerY.mas_equalTo(containView);
        }];
        nicknameLabel.text = @"好友";
        self.nicknameLabel = nicknameLabel;
        
        
    }
    return self;
}

- (void)setContactsModel:(IMContactsModel *)contactsModel{

    _contactsModel = contactsModel;
    
    self.nicknameLabel.text = contactsModel.nickName;
    if(contactsModel.avatarImage){
    
        self.avatarImageView.image = [UIImage imageNamed:contactsModel.avatarImage];

    }
}

@end
