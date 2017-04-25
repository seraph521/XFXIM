//
//  IMDatabaseHelper.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUser.h"
#import "IMConversation.h"

@interface IMDatabaseHelper : NSObject

+ (instancetype)sharedInstance;

#pragma mark - 用户相关
- (IMUser *)getUserWithUserId:(int64_t)userId;

#pragma mark - 会话相关
- (IMConversation *)getConversationWithId:(NSString *)conversationId;

#pragma mark - 消息相关
- (NSArray *)getFriendChatMessagesWithConversationId:(NSString *)conversationId page:(NSInteger)pageNum limit:(NSInteger)count;
@end
