//
//  GDCacheService.h
//  GapDay
//
//  Created by tommy on 16/7/24.
//  Copyright © 2016年 eva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDCacheService : NSObject

- (void)cacheUserContactArrray:(NSArray *)contactArray;

- (NSArray *)fetchUserContactArray;

+ (instancetype)sharedInstance;

#pragma mark - 缓存用户会话
- (void)cacheUserConversation:(AVIMConversation *)conversation withConversationId:(NSString *)coversationId;

- (AVIMConversation *)fetchFriendConversationWithConversationId:(NSString *)coversationId;

#pragma mark - 缓存聊天界面头像
- (void)cacheUserChatHeaderImage:(UIImage *)image withUrl:(NSString *)url;

- (UIImage *)fetchUserChatHeaderImageWithUrl:(NSString *)url;

#pragma mark - 缓存视频或图片消息的缩略图
- (void)cacheImageVideoThumbnailImage:(UIImage *)thumbnailImage withMessageId:(NSString *)messageId;

- (UIImage *)fetchImageVideoThumbnailImageWithMessageId:(NSString *)messageId;

#pragma mark - 缓存贴纸数据
- (void)cacheStickerImageArray:(NSArray *)stickerArray;

- (NSArray *)fetchStickerArray;

@end
