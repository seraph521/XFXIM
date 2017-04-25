//
//  IMUser+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/24.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMUser.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMUser (CoreDataProperties)

+ (NSFetchRequest<IMUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nullable, nonatomic, copy) NSNumber *gender;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nullable, nonatomic, copy) NSString *sign;
@property (nullable, nonatomic, copy) NSNumber *uid;
@property (nullable, nonatomic, retain) IMConversation *conversation;
@property (nullable, nonatomic, retain) NSSet<IMMessage *> *messages;

@end

@interface IMUser (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(IMMessage *)value;
- (void)removeMessagesObject:(IMMessage *)value;
- (void)addMessages:(NSSet<IMMessage *> *)values;
- (void)removeMessages:(NSSet<IMMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
