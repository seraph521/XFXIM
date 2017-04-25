//
//  IMGroup+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/24.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMGroup.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMGroup (CoreDataProperties)

+ (NSFetchRequest<IMGroup *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *conversationId;
@property (nullable, nonatomic, copy) NSNumber *create_id;
@property (nullable, nonatomic, copy) NSString *favicon;
@property (nullable, nonatomic, copy) NSString *group_description;
@property (nullable, nonatomic, copy) NSString *group_name;
@property (nullable, nonatomic, copy) NSNumber *groupId;
@property (nullable, nonatomic, copy) NSNumber *member_count;
@property (nullable, nonatomic, retain) IMConversation *conversation;

@end

NS_ASSUME_NONNULL_END
