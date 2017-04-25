//
//  IMChatService.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVOSCloudIM.h>


typedef void(^sendTextMessageBlock)(AVIMConversation * conversation, NSString * text);
typedef sendTextMessageBlock MPSendTextBlock;

typedef void(^sendTypedMessageBlock)(AVIMConversation * conversation,NSString * filePath);
typedef sendTypedMessageBlock MPSendTypedBlock;

typedef void(^sendMessageBlock)(int code, NSString * text);
typedef sendMessageBlock MPSendGiftBlock;

@interface IMChatService : NSObject<NSCopying>

+ (instancetype)sharedInstance;

#pragma mark - 消息发送
//发送文字消息
- (void)sendTextMessageToUser:(NSString *)userId withConversationId:(NSString *)conversationId andText:(NSString *)text isGroup:(BOOL)isGroup;

@end
