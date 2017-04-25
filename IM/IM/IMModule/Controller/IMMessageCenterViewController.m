//
//  IMMessageCenterViewController.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMMessageCenterViewController.h"
#import "IMChattingViewController.h"
#import "IMConversation.h"
#import "IMManager.h"
#import "IMLoginUserModel.h"

static NSString * CONVERSATION_CELL = @"conversation_cell";

@interface IMMessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * conversationTableView;

@property(nonatomic,strong) NSMutableArray * conversationArray;

@property(nonatomic,strong) NSMutableArray * friendsArray;

@end

@implementation IMMessageCenterViewController

- (NSMutableArray *)friendsArray{

    if(_friendsArray == nil){
    
        _friendsArray = [NSMutableArray array];
        IMLoginUserModel * model1 = [[IMLoginUserModel alloc] init];
        model1.uid = 123;
        model1.uname = @"懒羊羊";
//         model1.uid = 321;
//         model1.uname = @"小懒";

//        IMLoginUserModel * model2 = [[IMLoginUserModel alloc] init];
//        model2.uid = 1235;
//        model2.uname = @"短短";
        
        [_friendsArray addObject:model1];
 //       [_friendsArray addObject:model2];
    }
    return _friendsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景图片
    [self setupBackgroundImage];
    //设置返回按钮
    [self setupBackButton];
    
    [self setupTableView];
    
    [self setupContactButtons];
}


- (void)setupBackgroundImage{

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

- (void)setupBackButton{

    UIImage * arrowImage = [UIImage imageNamed:@"main_nav_back_white"];
    UIButton * backBtn = [[UIButton alloc] init];
    [backBtn setImage:arrowImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(handleNavBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    CGFloat offset = [UIView lf_sizeFromIphone6:30];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(offset);
        make.size.mas_equalTo([UIView lf_sizeFromIphone6:40]);
    }];
    
}

- (void)setupTableView{

    UITableView * tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CONVERSATION_CELL];
    [self.view addSubview:tableView];
   
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, [UIView lf_sizeFromIphone6:56], 0));
    }];

    self.conversationTableView = tableView;

}

- (void)setupContactButtons{

    UIButton * contactButton = [[UIButton alloc] init];
    [contactButton setImage:[UIImage imageNamed:@"message_center_contact"] forState:UIControlStateNormal];
    [contactButton setTitle:@"联系人" forState:UIControlStateNormal];
    contactButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [contactButton setTintColor:[UIColor whiteColor]];
    [contactButton addTarget:self action:@selector(handleContactButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    contactButton.titleEdgeInsets = UIEdgeInsetsMake(0, [UIView lf_sizeFromIphone6:12], 0, -[UIView lf_sizeFromIphone6:12]);
    [self.view addSubview:contactButton];
    
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset([UIView lf_sizeFromIphone6:18]);
        make.bottom.equalTo(self.view).offset(-[UIView lf_sizeFromIphone6:14]);
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.friendsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    IMLoginUserModel * model = self.friendsArray[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CONVERSATION_CELL];
    cell.textLabel.text = model.uname;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    #pragma mark - 直接进入单聊界面
    
    IMLoginUserModel * userModel = [IMLoginUserModelArchieveTool userInfoUnAchieveFromFile];
    IMLoginUserModel * model = self.friendsArray[indexPath.row];
    //与同一人会话唯一ID
     NSString * conversationId = [IMUtil md5:[NSString stringWithFormat:@"%zd_%zd",userModel.uid,model.uid]];
    //是否已有会话,没有则创建会话
    IMConversation * conversation = [[IMDatabaseHelper sharedInstance] getConversationWithId:conversationId];
    if(!conversation){
        conversation = [IMConversation MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    conversation.conversationId = conversationId;
    conversation.lastMessageContent = @"你们还没有进行互动哦!";
    
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate * recordDate = [dateFormatter dateFromString:model.push_datetime];
      int64_t timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    conversation.lastUpdateTime = @(timeStamp);
    
    conversation.type = kIMConversationTypeSingle;
    //将该回话的未读数目置为0
    conversation.unReadCount = 0;
    
    //设置IMUser
    IMUser * user = [[IMDatabaseHelper sharedInstance] getUserWithUserId:model.uid];
    if(!user){
        user = [IMUser MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    user.nickname = model.uname;
    user.uid = @(model.uid);
    conversation.user = user;
    
    [[IMManager sharedInstance] setupChattingConversationId:conversation.conversationId];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        //跳转到聊天会话
        IMChattingViewController * chattingViewController = [[IMChattingViewController alloc] init];
        chattingViewController.conversation = conversation;

        [self.navigationController pushViewController:chattingViewController animated:YES];
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



//联系人
- (void)handleContactButtonEvent{

    NSLog(@"=======联系人");
}



- (void)handleNavBack{

    [self.navigationController popViewControllerAnimated:YES];
}

@end
