//
//  IMSlideViewController.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/28.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMSlideViewController.h"
#import "IMSlideViewCell.h"
#import "IMSlideHeaderView.h"
#import "IMSlideModel.h"

#define MAX_SLIDE_WIDTH SCREEN_WIDTH * 0.8
static NSString * IMSLIDEVIEW_CELL =  @"IMSlideView_cell";

@interface IMSlideViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tableView;

@property(nonatomic,strong) UIView * headerView;

@property(nonatomic,strong) NSTimer * timer;

@property(nonatomic,strong) NSMutableArray * itemArray;

@end

@implementation IMSlideViewController

- (NSMutableArray *)itemArray{

    if(_itemArray == nil){
    
        _itemArray = [NSMutableArray array];
        
        IMSlideModel * model0 = [[IMSlideModel alloc] init];
        model0.title = @"收藏";
        model0.iconName = @"collection";
        
        IMSlideModel * model1 = [[IMSlideModel alloc] init];
        model1.title = @"关注";
        model1.iconName = @"flag";
        
        IMSlideModel * model2 = [[IMSlideModel alloc] init];
        model2.title = @"风格";
        model2.iconName = @"style";
        
        IMSlideModel * model3 = [[IMSlideModel alloc] init];
        model3.title = @"设置";
        model3.iconName = @"setting";
        
        [_itemArray addObject:model0];
        [_itemArray addObject:model1];
        [_itemArray addObject:model2];
        [_itemArray addObject:model3];
    }
    
    return _itemArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
   // [self setupTime];
}

- (void)setupView{

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarHidden = YES;
    
    UITableView * tableView = [[UITableView alloc] init];
    [tableView registerClass:[IMSlideViewCell class] forCellReuseIdentifier:IMSLIDEVIEW_CELL];
    tableView.frame = CGRectMake(0, 0, MAX_SLIDE_WIDTH, SCREEN_HEIGHT);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //headerView
    IMSlideHeaderView * slideHeaderView = [[IMSlideHeaderView alloc] init];
    slideHeaderView.size = [slideHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.tableView.tableHeaderView = slideHeaderView;
    
}

- (void)setupTime{

    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollVewAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
    
}

- (void)scrollVewAnimation{

    NSLog(@"============");
}

#pragma mark - UITableViewDataSouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    IMSlideModel * model  = self.itemArray[indexPath.row];
    IMSlideViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IMSLIDEVIEW_CELL];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"=====didSelectRowAtIndexPath=");
}

@end
