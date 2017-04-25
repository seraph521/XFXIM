//
//  IMConversation+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/24.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMConversation.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMConversation (CoreDataProperties)

+ (NSFetchRequest<IMConversation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *conversationId;
@property (nullable, nonatomic, copy) NSNumber *is_shied;
@property (nullable, nonatomic, copy) NSString *lastMessageContent;
@property (nullable, nonatomic, copy) NSNumber *lastUpdateTime;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSNumber *unReadCount;
@property (nullable, nonatomic, retain) IMGroup *group;
@property (nullable, nonatomic, retain) IMUser *user;

@end

NS_ASSUME_NONNULL_END
