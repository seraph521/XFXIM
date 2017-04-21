//
//  IMGroup+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMGroup (CoreDataProperties)

+ (NSFetchRequest<IMGroup *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *conversationId;
@property (nonatomic) int64_t create_id;
@property (nullable, nonatomic, copy) NSString *favicon;
@property (nullable, nonatomic, copy) NSString *group_description;
@property (nullable, nonatomic, copy) NSString *group_name;
@property (nonatomic) int64_t groupId;
@property (nonatomic) int16_t member_count;
@property (nullable, nonatomic, retain) IMConversation *conversation;

@end

NS_ASSUME_NONNULL_END
