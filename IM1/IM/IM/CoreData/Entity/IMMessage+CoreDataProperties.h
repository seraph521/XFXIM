//
//  IMMessage+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMMessage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMMessage (CoreDataProperties)

+ (NSFetchRequest<IMMessage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *conversationId;
@property (nonatomic) int64_t createTime;
@property (nonatomic) int64_t friendId;
@property (nonatomic) int64_t fromPeerId;
@property (nullable, nonatomic, copy) NSString *messageId;
@property (nonatomic) BOOL needShowmessageTime;
@property (nonatomic) BOOL sendFromMe;
@property (nonatomic) int16_t status;
@property (nonatomic) int64_t toPeerId;
@property (nonatomic) int16_t type;
@property (nonatomic) int64_t updateTime;
@property (nullable, nonatomic, retain) IMMediaFile *midiaFile;
@property (nullable, nonatomic, retain) IMUser *user;

@end

NS_ASSUME_NONNULL_END
