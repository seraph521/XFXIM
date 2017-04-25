//
//  IMMessage+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/24.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMMessage.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMMessage (CoreDataProperties)

+ (NSFetchRequest<IMMessage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *conversationId;
@property (nullable, nonatomic, copy) NSNumber *createTime;
@property (nullable, nonatomic, copy) NSNumber *friendId;
@property (nullable, nonatomic, copy) NSNumber *fromPeerId;
@property (nullable, nonatomic, copy) NSString *messageId;
@property (nullable, nonatomic, copy) NSNumber *needShowmessageTime;
@property (nullable, nonatomic, copy) NSNumber *sendFromMe;
@property (nullable, nonatomic, copy) NSNumber *status;
@property (nullable, nonatomic, copy) NSNumber *toPeerId;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSNumber *undateTime;
@property (nullable, nonatomic, retain) IMMediaFile *midiaFile;
@property (nullable, nonatomic, retain) IMUser *user;

@end

NS_ASSUME_NONNULL_END
