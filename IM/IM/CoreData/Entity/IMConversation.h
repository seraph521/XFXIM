//
//  IMConversation+CoreDataClass.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger,IMConversationType) {
    kIMConversationTypeSingle = 0,
    kIMConversationTypeGroup
};

@class IMGroup, IMUser;

NS_ASSUME_NONNULL_BEGIN

@interface IMConversation : NSManagedObject

//- (IMConversation *)setupConversationWithContactModel:(IMContactModel *)contactModel;
//
//- (IMConversation *)setupConversationWithGroupModel:(IMGroupModel *)groupModel;

- (IMConversation *)setupConversationWithMessage:(IMMessage *)message;

- (IMConversation *)setupConversationWithConversationId:(NSString *)conversationId;

- (void)fetchNewAfterUpdate;

@end

NS_ASSUME_NONNULL_END

#import "IMConversation+CoreDataProperties.h"
