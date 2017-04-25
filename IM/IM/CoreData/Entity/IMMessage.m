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

@end
