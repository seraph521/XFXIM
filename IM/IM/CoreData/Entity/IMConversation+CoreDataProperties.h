//
//  IMConversation+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMConversation.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMConversation (CoreDataProperties)

+ (NSFetchRequest<IMConversation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *conversationId;
@property (nonatomic) int16_t is_shied;
@property (nullable, nonatomic, copy) NSString *lastMessageContent;
@property (nonatomic) int64_t lastUpdateTime;
@property (nonatomic) int16_t type;
@property (nonatomic) int16_t unReadCount;
@property (nullable, nonatomic, retain) IMGroup *group;
@property (nullable, nonatomic, retain) IMUser *user;

@end

NS_ASSUME_NONNULL_END
