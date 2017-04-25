//
//  IMChattingViewController.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMChattingViewController.h"
#import "EvaGrowingTextView.h"
#import "IMBaseMessageCell.h"
#import "IMTextMessageCell.h"
#import "IMMessage.h"

#define BASE_MESSAGE_CELL @"BASE_MESSAGE_CELL"
#define TEXT_MESSAGE_CELL @"TEXT_MESSAGE_CELL"

#define TEXTVIEW_HEIGHT      [UIView lf_sizeFromIphone6:35]
#define INPUTBAR_HEIGHT      [UIView lf_sizeFromIphone6:55]
#define KEYBOARD_VIEW_HEIGHT [UIView lf_sizeFromIphone6:285]
#define LINE_BUTTON_COUNT    10
#define LEFT_MARGIN          [UIView lf_sizeFromIphone6:5]
#define ASSET_BUTTON_MARGIN  [UIView lf_sizeFromIphone6:1]

static NSString * CONVERSATION_CELL = @"conversation_cell";

@interface IMChattingViewController ()<EvaGrowingTextViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{

    CGFloat _lastTextHeight;
}

@property(nonatomic,strong) UIView * bottomBar;

@property(nonatomic,strong) UIButton * cameraButton;

@property(nonatomic,strong) UIButton * voiceButton;

@property(nonatomic,strong) UIView * inputBar;

@property(nonatomic,strong) UIView * lineView;

@property(nonatomic,strong) EvaGrowingTextView * contentTextView;

//聊天消息部分
@property (nonatomic,strong) NSMutableArray * messageArray;

@end

@implementation IMChattingViewController

- (NSMutableArray *)messageArray
{
    if(_messageArray == nil){
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupBackgroundImage];
    
    [self setupNavItem];
    
    [self setupBottomView];
    
    [self setupInputBar];
    
    [self setupChattingTableView];
    
    [self registerNotification];
    
    [self setupMessageData];
    
    
}

-(void)setupBackgroundImage{

    UIImageView * bgImageView = [[UIImageView alloc] init];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.image = [UIImage imageNamed:@"bg2"];
    [self.view addSubview:bgImageView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)setupNavItem{

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置顶部会话所属人标题
    UIView * navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 64));
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = DreamColorWithAlpha(0, 0, 0, 0.1);
    [navView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(navView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH,1));
    }];
    
    UIImage * arrowImage = [UIImage imageNamed:@"main_nav_back"];
    UIButton * navBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, arrowImage.size.width, arrowImage.size.height)];
    [navBackButton setImage:arrowImage forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(handleNavBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:navBackButton];
    
    [navBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView).offset([UIView lf_sizeFromIphone6:5]);
        make.bottom.mas_equalTo(-(44 - arrowImage.size.height) * 0.5);
    }];

    UILabel * titlelabel = [[UILabel alloc] init];
    titlelabel.textColor = DreamColor(51, 51, 51);
    titlelabel.text = @"懒羊羊";
    [navView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(navView.mas_centerX);
        make.centerY.mas_equalTo(navBackButton.mas_centerY);
        
    }];
    
}

- (void)setupChattingTableView{

    UITableView * messageTableView = [[UITableView alloc] init];
    messageTableView.backgroundColor = [UIColor clearColor];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [messageTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CONVERSATION_CELL];
    [messageTableView registerClass:[IMBaseMessageCell class] forCellReuseIdentifier:BASE_MESSAGE_CELL];
    [messageTableView registerClass:[IMTextMessageCell class] forCellReuseIdentifier:TEXT_MESSAGE_CELL];
//    [messageTableView registerClass:[GDImageVideoMessageCell class] forCellReuseIdentifier:IMAGE_MESSAGE_CELL];
//    [messageTableView registerClass:[GDLocationMessageCell class] forCellReuseIdentifier:LOCATION_MESSAGE_CELL];
    [self.view addSubview:messageTableView];
    self.messageTableView = messageTableView;
    
    [messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(self.inputBar.mas_top);
    }];
}

- (void)setupBottomView{

    UIView * bottomBar = [[UIView alloc] init];
    bottomBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBar];
    self.bottomBar = bottomBar;
    
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [UIView lf_sizeFromIphone6:56]));
    }];
    
    //添加相机按钮
    UIButton * cameraButton = [[UIButton alloc] init];
    [cameraButton setImage:[UIImage imageNamed:@"message_camera_normal"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"message_camera_selected"] forState:UIControlStateSelected];
    [cameraButton addTarget:self action:@selector(handleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:cameraButton];
    self.cameraButton = cameraButton;
    
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBar).offset([UIView lf_sizeFromIphone6:45]);
        make.centerY.equalTo(bottomBar);
    }];
    
    //添加定位按钮
    UIButton * locateButton = [[UIButton alloc] init];
    [locateButton setImage:[UIImage imageNamed:@"message_location_icon"] forState:UIControlStateNormal];
    [locateButton addTarget:self action:@selector(handleLocateButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:locateButton];
    
    [locateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomBar);
    }];
    
    //添加语音按钮
    UIButton * voiceButton = [[UIButton alloc] init];
    [voiceButton setImage:[UIImage imageNamed:@"message_voice_record_normal"] forState:UIControlStateNormal];
    [voiceButton setImage:[UIImage imageNamed:@"message_voice_record_selected"] forState:UIControlStateSelected];
    [voiceButton addTarget:self action:@selector(handleVoiceRecordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:voiceButton];
    self.voiceButton = voiceButton;
    
    [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBar).offset(-[UIView lf_sizeFromIphone6:45]);
        make.centerY.equalTo(bottomBar);
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = DreamColorWithAlpha(0, 0, 0, 0.1);
    [bottomBar addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomBar);
        make.top.equalTo(bottomBar);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - [UIView lf_sizeFromIphone6:32], 1));
    }];

}

#pragma mark - setupInputBar

- (void)setupInputBar{

    UIView * inputBar = [[UIView alloc] init];
    inputBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputBar];
    self.inputBar = inputBar;
    
    [inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBar);
        make.bottom.equalTo(self.bottomBar.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [UIView lf_sizeFromIphone6:55]));
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = DreamColorWithAlpha(0, 0, 0, 0.1);
    lineView.alpha = 0.0;
    [inputBar addSubview:lineView];
    self.lineView = lineView;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(inputBar);
        make.top.equalTo(inputBar);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH , 1));
    }];
    
    UIButton * headerImageButton = [[UIButton alloc] init];
    [headerImageButton setBackgroundImage:[UIImage imageNamed:@"chat_header_bg"] forState:UIControlStateNormal];
    [inputBar addSubview:headerImageButton];
    
    [headerImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputBar).offset([UIView lf_sizeFromIphone6:12]);
        make.left.equalTo(inputBar).offset([UIView lf_sizeFromIphone6:15]);
        make.size.mas_equalTo([UIView lf_rectSizeFromIphone6:32]);
    }];

    //添加输入框
    EvaGrowingTextView * contentTextView = [[EvaGrowingTextView alloc] init];
    contentTextView.tintColor = [UIColor blackColor];
    contentTextView.returnKeyType = UIReturnKeySend;
    contentTextView.placeholderTitle = @"输入信息";
    contentTextView.delegate = self;
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.font = [UIFont systemFontOfSize:16];
    contentTextView.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    contentTextView.maxHeight = 120;
    [inputBar addSubview:contentTextView];
    self.contentTextView = contentTextView;
    
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageButton.mas_right).offset([UIView lf_sizeFromIphone6:20]);
        make.right.equalTo(inputBar).offset(-[UIView lf_sizeFromIphone6:16]);
        make.centerY.equalTo(inputBar);
        make.height.mas_equalTo([UIView lf_sizeFromIphone6:35]);
    }];

}

- (void)setupMessageData{

    
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IMMessage * message = self.messageArray[indexPath.row];
    IMTextMessageCell * textCell = [tableView dequeueReusableCellWithIdentifier:TEXT_MESSAGE_CELL];
    
    textCell.message = message;
    return textCell;
}

#pragma  mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.contentTextView resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    IMMessage * message = self.messageArray[indexPath.row];
    
    if([message.type integerValue] == kIMMessageTypeText){
    
        return [tableView fd_heightForCellWithIdentifier:TEXT_MESSAGE_CELL configuration:^(id cell) {
            ((IMTextMessageCell *) cell).message = message;
        }];
    }else{
    
        return 0;
    }
    
}






#pragma mark - registerNotification
- (void)registerNotification{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewMessage:) name:NOTIFICATION_SEND_NEWMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewMessage:) name:NOTIFICATION_RECEIVED_NEWMESSAGE object:nil];
}

#pragma mark - 消息接受与发送部分
- (void)handleNewMessage:(NSNotification *)notification
{
    IMMessage * message = [notification.userInfo objectForKey:@"message"];
    
    message = [message MR_inContext:[NSManagedObjectContext MR_defaultContext]];
    [IMUtil runInGlobalQueue:^{
        //判断消息是否属于当前会话
        if([message.conversationId isEqualToString:self.conversation.conversationId]){
            if(message){
                [IMUtil runInMainQueue:^{
                    //加入数据源
                    [self.messageArray addObject:message];
                    [self.messageTableView reloadData];
                    //将列表滑到最底下
                    [self scrollToBottomAnimated:YES];
                }];
            }
        }
    }];
}

#pragma mark - 滑动到最底部
- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:animated];
    }
}

- (void)handleNavBack{

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 底部按钮

- (void)handleCameraButtonEvent:(UIButton *) button{

}

- (void)handleVoiceRecordButtonEvent:(UIButton *) button{
    
}

- (void)handleLocateButtonEvent{
    
}

#pragma mark - EvaGrowingTextViewDelegate
- (void)updateContraintsWithNewHeight:(CGFloat)newHeight
{
    CGFloat bottomBarHeight;
    
    if(newHeight < TEXTVIEW_HEIGHT) {
        newHeight = TEXTVIEW_HEIGHT;
        bottomBarHeight = INPUTBAR_HEIGHT;
    } else {
        bottomBarHeight = newHeight + [UIView lf_sizeFromIphone6:20];
    }
    
    _lastTextHeight = newHeight;
    
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(newHeight);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.inputBar layoutIfNeeded];
    }];
    
    [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomBarHeight);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self.contentTextView scrollRangeToVisible:NSMakeRange(self.contentTextView.text.length - 1, 1)];
    
 //   [self scrollToBottomAnimated:YES];
}

/**
 *  UITextViewDelegate 用户发送文字消息
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.text.length > 0 && [text isEqualToString:@"\n"]){
        BOOL isGroup = [self.conversation.type integerValue]  == kIMConversationTypeGroup;
        //用户点击了发送，执行文字消息发送
        [[IMChatService sharedInstance] sendTextMessageToUser:isGroup?@"":[NSString stringWithFormat:@"%zd",[self.conversation.user.uid integerValue] ] withConversationId:self.conversation.conversationId andText:textView.text isGroup:isGroup];
        //清空文字输入
        self.contentTextView.text = @"";
        [((EvaGrowingTextView *)textView) manualLayoutSubViews];
        return NO;
    }else if(textView.text.length == 0 && [text isEqualToString:@"\n"]){
        return NO;
    }else{
        [((EvaGrowingTextView *)textView) manualLayoutSubViews];
    }
    return YES;
}


#pragma mark - NSNotification

- (void)keyboardWillShow:(NSNotification *)notification{

    CGRect keyboardFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(- keyboardHeight);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    
    [self.view layoutIfNeeded];
}

@end
