//
//  IMMessage+CoreDataClass.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IMMediaFile, IMUser;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IMMessageType) {
    kIMMessageTypeText = 0,
    kIMMessageTypeVoice,
    kIMMessageTypeImage,
    kIMMessageTypeVideo,
    kIMMessageTypeLocation
};

typedef NS_ENUM(NSUInteger,IMMessageStatus){
    kIMMessageStatusReaded = 0,
    kIMMessageStatusUnReaded,
    kIMMessageStatusSending,
    kIMMessageStatusSendFail,
    kIMMessageStatusSendSucceed
};

@interface IMMessage : NSManagedObject

@property (nonatomic,strong) NSDictionary * attrDict;

#pragma mark - 构建非富媒体消息数据
- (IMMessage *)setupDefaultNoRichMessageWithType:(IMMessageType)type text:(NSString *)text toUser:(NSInteger)userId inConversationWithId:(NSString *)conversationId;

- (IMMessage *)updateNoRichMessageWithIMMessage:(AVIMMessage *)message;

#pragma mark - 富媒体消息发送与接收
- (IMMessage *)setupDefaultTypedMessageWithType:(IMMessageType)type mediaFile:(IMMediaFile *)mediaFile toUser:(NSInteger)userId inConversationWithId:(NSString *)conversationId;

//消息发送过后更新富媒体消息
- (IMMessage *)updateTypedMessageWithMessage:(AVIMTypedMessage *)message;

#pragma mark - 消息接收时处理
- (IMMessage *)setupWithTypedMessage:(AVIMTypedMessage *)message;

#pragma mark -  消息发送失败
- (IMMessage *)updateToFailedMessage;

@end

NS_ASSUME_NONNULL_END

#import "IMMessage+CoreDataProperties.h"
