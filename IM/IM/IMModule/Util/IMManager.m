//
//  IMManager.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMManager.h"
#import "IMMessage.h"

static IMManager * manager;
static NSString * chattingConversationId;

@interface IMManager ()<AVIMClientDelegate>

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;

@end


@implementation IMManager


- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext == nil){
        _managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    }
    return _managedObjectContext;
}
#pragma mark - Singleton
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    
    return manager;
    
}

-(id)copyWithZone:(NSZone *)zone
{
    return manager;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return manager;
}

+ (instancetype)sharedInstance{

    return [[self alloc] init];
}


#pragma mark - lazy load
- (AVIMClient *)imClient{

    if(_imClient == nil){
    
        _imClient = [[AVIMClient alloc]init];
        _imClient.delegate = self;
    }
    return _imClient;
}

- (void)startIMClient{

    IMLoginUserModel * userModel = [IMLoginUserModelArchieveTool userInfoUnAchieveFromFile];
    [self.imClient openWithClientId:[NSString stringWithFormat:@"%zd",userModel.uid] callback:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            NSLog(@"=====startClick=succeeded");
        }
    }];
}


- (void)setupChattingConversationId:(NSString *)conversationId
{
    chattingConversationId = conversationId;
}

#pragma mark - AVIMClientDelegate

/*!
 当前聊天状态被暂停，常见于网络断开时触发。
 */
- (void)imClientPaused:(AVIMClient *)imClient{

}

/*!
 当前聊天状态被暂停，常见于网络断开时触发，error 包含暂停的错误信息。
 注意：该回调会覆盖 imClientPaused: 方法。
 */
- (void)imClientPaused:(AVIMClient *)imClient error:(NSError *)error{

}

/*!
 当前聊天状态开始恢复，常见于网络断开后开始重新连接。
 */
- (void)imClientResuming:(AVIMClient *)imClient{

}

/*!
 当前聊天状态已经恢复，常见于网络断开后重新连接上。
 */
- (void)imClientResumed:(AVIMClient *)imClient{

}

/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{

}

/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    
    IMLoginUserModel * loginModel = [IMLoginUserModelArchieveTool userInfoUnAchieveFromFile];
    NSString * conversationId = [IMUtil md5:[NSString stringWithFormat:@"%zd_%zd",loginModel.uid,[message.clientId integerValue]]];
    
    IMConversation * dbConversation = [[IMDatabaseHelper sharedInstance] getConversationWithId:conversationId];
    if([dbConversation.is_shied integerValue] == 1){
        return;
    }
    
    if([message.clientId integerValue] == loginModel.uid){
        return;
    }

    //处理消息接收
    if([message isKindOfClass:[AVIMTextMessage class]]){
        //处理文字消息
        [self handleReceivedTextMessage:(AVIMTextMessage *)message];
    }
}

/*!
 消息已投递给对方。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message{

    NSLog(@"=============对方已经收到消息");
}


#pragma mark - 消息接受处理中心
- (void)handleReceivedTextMessage:(AVIMTypedMessage *)message{

    IMMessage * textMessage = [IMMessage MR_createEntityInContext:self.managedObjectContext];
    [textMessage setupWithTypedMessage:message];
    NSLog(@"=========消息===%@",message);
    
    [self.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        //发送通知刷新页面
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RECEIVED_NEWMESSAGE object:nil userInfo:@{@"message":textMessage}];
        
    }];
 
}

@end
