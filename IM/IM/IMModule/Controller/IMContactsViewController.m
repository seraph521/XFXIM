//
//  IMContactsViewController.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/28.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMContactsViewController.h"
#import "IMContactsCell.h"

static NSString * CONTACTS_CELL = @"contacts_cell";

@interface IMContactsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tableView;

@property(nonatomic,strong) NSMutableArray * contactsArray;

@end

@implementation IMContactsViewController

- (NSMutableArray * )contactsArray{

    if(_contactsArray == nil){
    
        _contactsArray = [NSMutableArray array];
        
        for(int i=0;i<10;i++){
        
            IMContactsModel * model = [[IMContactsModel alloc] init];
            model.nickName = [NSString stringWithFormat:@"好友%d",i];
            [_contactsArray addObject:model];
        }

    }
    return _contactsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackGroundView];
    [self setupChildView];
}

- (void)setupBackGroundView{

    UIImageView * bgImageView = [[UIImageView alloc] init];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.image = [UIImage imageNamed:@"bg1"];
    [self.view addSubview:bgImageView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    UIView * coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self.view addSubview:coverView];
    
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}


- (void)setupChildView{

    UITableView * tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[IMContactsCell class] forCellReuseIdentifier:CONTACTS_CELL];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma mark - UItableViewDataSouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.contactsArray.count;
}

- (UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    IMContactsModel * model = self.contactsArray[indexPath.row];
    IMContactsCell * cell = [tableView dequeueReusableCellWithIdentifier:CONTACTS_CELL];
    cell.contactsModel = model;
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [UIView lf_sizeFromIphone6:60];
}

@end
