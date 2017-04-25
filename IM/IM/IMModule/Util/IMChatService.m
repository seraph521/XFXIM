//
//  IMChatService.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMChatService.h"
#import "IMManager.h"
#import "IMMessage.h"

static IMChatService * iMChatService;

@interface IMChatService ()

@property (nonatomic,strong) IMManager * imManager;
@property (nonatomic,strong) IMDatabaseHelper * dbHelper;
@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;

@end

@implementation IMChatService

- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext == nil){
        _managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    }
    return _managedObjectContext;
}

#pragma mark - 单例模式
+ (instancetype) allocWithZone:(struct _NSZone *)zone{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iMChatService = [super allocWithZone:zone];
    });
    return iMChatService;
}

- (id)copyWithZone:(NSZone *)zone{

    return iMChatService;
}

- (id)mutableCopyWithZone:(NSZone *)zone{

    return iMChatService;
}


+ (instancetype)sharedInstance{

    return [[self alloc] init];
}


#pragma mark - 消息发送
//发送文字消息
- (void)sendTextMessageToUser:(NSString *)userId withConversationId:(NSString *)conversationId andText:(NSString *)text isGroup:(BOOL)isGroup
{

    //根据conversationId 开启会话
    NSString * currentUserId = [NSString stringWithFormat:@"%zd",[IMLoginUserModelArchieveTool userInfoUnAchieveFromFile].uid];
    
    [[IMManager sharedInstance].imClient createConversationWithName:@"chat" clientIds:@[userId,currentUserId] callback:^(AVIMConversation *conversation, NSError *error) {
        
        //发送消息
        if(text){
            
            //直接更新消息界面
            IMMessage * dbTextMessage = [IMMessage MR_createEntity];
            [dbTextMessage setupDefaultNoRichMessageWithType:kIMMessageTypeText text:text toUser:[userId integerValue] inConversationWithId:conversationId];
            dbTextMessage.conversationId = conversationId;
            //插入会话
            IMConversation * dbConversation = [[IMDatabaseHelper sharedInstance] getConversationWithId:conversationId];
            if(dbConversation){
                dbConversation = [dbConversation setupConversationWithMessage:dbTextMessage];
            }else{
                dbConversation = [IMConversation MR_createEntity];
                dbConversation = [dbConversation setupConversationWithMessage:dbTextMessage];
                
                NSString * conversationId = [IMUtil getConversationIdWithUserId:userId];
                dbConversation.conversationId = conversationId;
            }
            //发送通知，将消息展示到页面中
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SEND_NEWMESSAGE object:nil userInfo:@{@"message":dbTextMessage}];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_CONVERSATIONLIST object:nil];
            
            IMLoginUserModel * loginUserModel = [IMLoginUserModelArchieveTool userInfoUnAchieveFromFile];
            
            AVIMTextMessage * textMessage = [AVIMTextMessage messageWithText:text attributes:@{@"nickName":loginUserModel.uname,@"avatar":@"avatar",@"uid":@(loginUserModel.uid),@"isGroupMessage":@(isGroup?1:0)}];
            
            if(!conversation){
                [dbTextMessage updateToFailedMessage];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_MESSAGE_STATUS object:nil userInfo:@{@"message":dbTextMessage}];
                [self.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {}];
                return;
            }
            
            //=====发送消息=====
            
            [conversation sendMessage:textMessage callback:^(BOOL succeeded, NSError *error) {
                
                if(!error){
                    //消息发送完成，更新数据库，缓存消息，然后刷新聊天界面
                    NSLog(@"文字消息已发送");
                    [dbTextMessage updateNoRichMessageWithIMMessage:textMessage];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_MESSAGE_STATUS object:nil userInfo:@{@"message":dbTextMessage}];
                    [self.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {}];
                }else{
                    [dbTextMessage updateNoRichMessageWithIMMessage:textMessage];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_MESSAGE_STATUS object:nil userInfo:@{@"message":dbTextMessage}];
                    
                    [self.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {}];
                }
                
            }];
            
            
        }

    }];
    
    

    
    
}

@end
