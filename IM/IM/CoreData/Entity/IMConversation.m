//
//  IMConversation+CoreDataClass.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMConversation.h"
#import "IMGroup.h"
#import "IMUser.h"
#import "IMMessage.h"
@implementation IMConversation

- (IMConversation *)setupConversationWithMessage:(IMMessage *)message
{
    return [self setupDataWithMPMessage:message];
}


- (IMConversation *)setupDataWithMPMessage:(IMMessage *)message
{
    switch ([message.type intValue]) {
        case kIMMessageTypeText:{
            self.lastMessageContent = message.content;
            break;
        }
        case kIMMessageTypeVoice:{
            self.lastMessageContent = @"[语音]";
            break;
        }
        case kIMMessageTypeImage:{
            self.lastMessageContent = @"[图片]";
            break;
        }
        case kIMMessageTypeVideo:{
            self.lastMessageContent = @"[视频]";
            break;
        }
        case kIMMessageTypeLocation:{
            self.lastMessageContent = @"[位置]";
            break;
        }
        default:
            break;
    }
    if(!message){
        self.lastUpdateTime = @([IMUtil getCurrentTimestamp]);
        self.lastMessageContent = @"你们还没有聊天消息";
    }else{
        self.lastUpdateTime = message.createTime;
    }
    return self;
}
@end
