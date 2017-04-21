//
//  IMUser+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMUser (CoreDataProperties)

+ (NSFetchRequest<IMUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nonatomic) int16_t gender;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nullable, nonatomic, copy) NSString *sign;
@property (nonatomic) int64_t uid;
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
