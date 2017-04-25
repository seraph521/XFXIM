//
//  GDCacheService.m
//  GapDay
//
//  Created by tommy on 16/7/24.
//  Copyright © 2016年 eva. All rights reserved.
//

#import "GDCacheService.h"

static GDCacheService * service;

@interface GDCacheService ()

@property (nonatomic,strong) NSArray * contactArray;

@property (nonatomic,strong) NSArray * stickerArray;

@property (nonatomic,strong) NSMutableDictionary * friendConversationCache;

@property (nonatomic,strong) NSMutableDictionary * imageVideoThumbnailImageCache;

@property (nonatomic,strong) NSMutableDictionary * userChatHeaderImageCache;

@end

@implementation GDCacheService

#pragma mark - 单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [super allocWithZone:zone];
    });
    return service;
}

+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

#pragma mark - lazy load
- (NSArray *)contactArray
{
    if(_contactArray == nil){
        _contactArray = [NSMutableArray array];
    }
    return _contactArray;
}

- (NSArray *)stickerArray
{
    if(_stickerArray == nil){
        _stickerArray = [NSMutableArray array];
    }
    return _stickerArray;
}

- (NSMutableDictionary *)friendConversationCache
{
    if(_friendConversationCache == nil){
        _friendConversationCache = [NSMutableDictionary dictionary];
    }
    return _friendConversationCache;
}

- (NSMutableDictionary *)imageVideoThumbnailImageCache
{
    if(_imageVideoThumbnailImageCache == nil){
        _imageVideoThumbnailImageCache = [NSMutableDictionary dictionary];
    }
    return _imageVideoThumbnailImageCache;
}

- (NSMutableDictionary *)userChatHeaderImageCache
{
    if(_userChatHeaderImageCache == nil){
        _userChatHeaderImageCache = [NSMutableDictionary dictionary];
    }
    return _userChatHeaderImageCache;
}

#pragma mark - 缓存联系人
- (void)cacheUserContactArrray:(NSArray *)contactArray
{
    self.contactArray = contactArray;
}

- (NSArray *)fetchUserContactArray
{
    return self.contactArray;
}

#pragma mark - 缓存用户会话
- (void)cacheUserConversation:(AVIMConversation *)conversation withConversationId:(NSString *)coversationId
{
    if(coversationId && conversation){
        [self.friendConversationCache setValue:conversation forKey:coversationId];
    }
}

- (AVIMConversation *)fetchFriendConversationWithConversationId:(NSString *)coversationId
{
    AVIMConversation * conversation;
    if(coversationId){
        conversation = [self.friendConversationCache valueForKey:coversationId];
    }
    return conversation;
}

#pragma mark - 缓存聊天界面头像
- (void)cacheUserChatHeaderImage:(UIImage *)image withUrl:(NSString *)url
{
    if(image && url){
        [self.userChatHeaderImageCache setValue:image forKey:url];
    }
}

- (UIImage *)fetchUserChatHeaderImageWithUrl:(NSString *)url
{
    UIImage * image;
    if(url){
        image = [self.userChatHeaderImageCache valueForKey:url];
    }
    return image;
}

#pragma mark - 缓存视频或图片消息的缩略图
- (void)cacheImageVideoThumbnailImage:(UIImage *)thumbnailImage withMessageId:(NSString *)messageId
{
    if(thumbnailImage && messageId){
        [self.imageVideoThumbnailImageCache setValue:thumbnailImage forKey:messageId];
    }
}

- (UIImage *)fetchImageVideoThumbnailImageWithMessageId:(NSString *)messageId
{
    UIImage * image;
    if(messageId){
        image = [self.imageVideoThumbnailImageCache valueForKey:messageId];
    }
    return image;
}

#pragma mark - 缓存贴纸数据
- (void)cacheStickerImageArray:(NSArray *)stickerArray
{
    self.stickerArray = stickerArray;
}

- (NSArray *)fetchStickerArray
{
    return self.stickerArray;
}

@end
