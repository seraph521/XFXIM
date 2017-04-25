//
//  IMMessage+CoreDataClass.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMMessage.h"
#import "IMMediaFile.h"
#import "IMUser.h"
@implementation IMMessage
@synthesize attrDict;



//构建默认非富媒体消息数据

- (IMMessage *)setupDefaultNoRichMessageWithType:(IMMessageType)type text:(NSString *)text toUser:(NSInteger)userId inConversationWithId:(nonnull NSString *)conversationId
{
    self.type = @(type);
    self.status = @(kIMMessageStatusSending);
    self.createTime = @([[NSDate date] timeIntervalSince1970] * 1000);
    self.undateTime = @([[NSDate date] timeIntervalSince1970] * 1000);
    //先预分配一个messageId,待消息发送完毕之后再用服务器上的messageId覆盖
    self.messageId = [IMUtil uuid];
    if(type == kIMMessageTypeText) {
        self.content = text;
    }
    
    IMLoginUserModel * loginModel = [IMLoginUserModelArchieveTool userInfoUnAchieveFromFile];
    self.fromPeerId = @(loginModel.uid);
    self.toPeerId = @(userId);
    self.friendId = @(userId);
    //确定是否需要显示时间
    [self confirmIfNeedToShowMessageTimeWithConversationId:conversationId];
    self.sendFromMe = @(YES);
    return self;
}

- (IMMessage *)updateNoRichMessageWithIMMessage:(AVIMMessage *)message
{
    //设置消息状态
    if(message.status == AVIMMessageStatusFailed){
        self.status = @(kIMMessageStatusSendFail);
    }else if(message.status == AVIMMessageStatusSent){
        self.status = @(kIMMessageStatusSendSucceed);
    }
    self.undateTime = @([[NSDate date] timeIntervalSince1970] * 1000);
    self.messageId = message.messageId;
    return self;
}

// 确定是否需要显示时间
- (void)confirmIfNeedToShowMessageTimeWithConversationId:(NSString *)conversationId
{
    //获取最近的一条消息
    NSArray * messageArray = [[IMDatabaseHelper sharedInstance] getFriendChatMessagesWithConversationId:conversationId page:0 limit:2];
    if(messageArray.count == 0){
        //没有找到历史消息
        self.needShowmessageTime = @(YES);
    }else{
        if(messageArray.count == 1){
            IMMessage * message = [messageArray firstObject];
            if([message.messageId isEqualToString:self.messageId]){
                //可能只有当前一条消息
                self.needShowmessageTime = @(YES);
            }else{
                int timeOffset = (int)(([self.createTime longLongValue] - [message.createTime longLongValue] ) / 1000);
                if(timeOffset > 2 * 60){
                    //与上一条聊天记录的时间超过2分钟
                    self.needShowmessageTime = @(YES);
                }else{
                    self.needShowmessageTime = @(NO);
                }
            }
        }else{
            //除了当前消息之外，还存在一条历史消息，则计算时间差值
            IMMessage * tempMessage = [messageArray lastObject];
            IMMessage * lastMessage = [messageArray firstObject];
            
            int timeOffset = 0;
            if([tempMessage.messageId isEqualToString:self.messageId]){
                timeOffset = (int)(([self.createTime longLongValue]  - [lastMessage.createTime longLongValue])  / 1000);
            }else{
                timeOffset = (int)(([self.createTime longLongValue] - [tempMessage.createTime longLongValue]) / 1000);
            }
            
            if(timeOffset > 2 * 60){
                //与上一条聊天记录的时间超过2分钟
                self.needShowmessageTime = @(YES);
            }else{
                self.needShowmessageTime = @(NO);
            }
        }
    }
}

#pragma mark - 消息接收时处理
- (IMMessage *)setupWithTypedMessage:(AVIMTypedMessage *)message{
 
    self.attrDict = message.attributes;
    
    if(message.mediaType == kAVIMMessageMediaTypeAudio){
        self.type = @(kIMMessageTypeVoice);
    }else if(message.mediaType == kAVIMMessageMediaTypeImage){
        self.type = @(kIMMessageTypeImage);
    }else if(message.mediaType == kAVIMMessageMediaTypeVideo){
        self.type = @(kIMMessageTypeVideo);
    }else if(message.mediaType == kAVIMMessageMediaTypeText){
        self.type = @(kIMMessageTypeText);
    }else if(message.mediaType == kAVIMMessageMediaTypeLocation){
        self.type = @(kIMMessageTypeLocation);
    }
    
    //设置消息状态
    self.status = @(kIMMessageStatusUnReaded);
    
    if(message.mediaType == kAVIMMessageMediaTypeText){
        self.content = message.text;
    }
    
    //设置更新时间和创建时间
    self.undateTime = @([[NSDate date] timeIntervalSince1970] * 1000);
    self.createTime = @(message.sendTimestamp);
    
    //设置发送人和接收人
    IMLoginUserModel * loginModel = [IMLoginUserModelArchieveTool userInfoUnAchieveFromFile];
    self.fromPeerId = @([message.clientId integerValue]);
    self.toPeerId = @(loginModel.uid);
    self.friendId = @([message.clientId integerValue]);
    self.messageId = message.messageId;
    self.sendFromMe = @(NO);
//#warning 单聊这里要等服务器规划好conversation之后替换（暂且使用MD5(uid+ "_" +clientid)代替）
    if([[attrDict valueForKey:@"isGroupMessage"] intValue] == 1){
        self.conversationId = message.conversationId;
    }else{
        self.conversationId = [IMUtil md5:[NSString stringWithFormat:@"%zd_%zd",loginModel.uid,[message.clientId integerValue]]];
    }
    
    //确定是否需要显示时间
    [self confirmIfNeedToShowMessageTimeWithConversationId:self.conversationId];
    
    //绑定user
    IMUser * user = [[IMDatabaseHelper sharedInstance] getUserWithUserId:[message.clientId integerValue]];
    if(!user){
        user = [IMUser MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    //设置属性数据
    [user setupUserWithInfoDict:self.attrDict];
    self.user = user;
    
    return self;
}

@end
