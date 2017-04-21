//
//  IMChatService.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMChatService.h"
#import "IMManager.h"

static IMChatService * iMChatService;


@implementation IMChatService

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

    //根据conversationId
    
    
    //根据conversationId 开启会话
//    [[IMManager sharedInstance].imClient createConversationWithName:conversationId clientIds:@[conversationId] callback:^(AVIMConversation *conversation, NSError *error) {
//        
//        [conversation sendMessage:[AVIMTextMessage messageWithText:@"耗子，起床！" attributes:nil] callback:^(BOOL succeeded, NSError *error) {
//            NSLog(@"=========发送会话成功");
//        }];
//    }];
    
    //定义发送消息block
    MPSendTextBlock messageSendBlock = ^(AVIMConversation * conversation, NSString * text){
    
    
    
    
    }
    
    
    
    
}

@end
