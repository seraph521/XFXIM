//
//  IMManager.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,IMConvType){
    
    kIMConvTypeSingle = 0, //单聊
    kIMConvTypeGroup       //群聊
};


@interface IMManager : NSObject<AVIMClientDelegate>

@property (nonatomic,strong) AVIMClient * imClient;


//单例
+ (instancetype)sharedInstance;

- (void)startIMClient;

- (void)setupChattingConversationId:(NSString *)conversationId;

//#pragma mark - 获取单人聊天会话
//- (void)fetchConvWithConversationId:(NSString *)converstaionId callback:(AVIMConversationResultBlock)callback;
//
//- (void)fetchConvWithUserId:(NSString *)userId callback:(AVIMConversationResultBlock)callback;
//#pragma mark - 获取聊天室会话
//- (void)fetchChatRoomConversationWithChatRoomNum:(NSString *)chatRoomNum callback:(AVIMConversationResultBlock)callback;

@end
