//
//  IMMessage+CoreDataProperties.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMMessage+CoreDataProperties.h"

@implementation IMMessage (CoreDataProperties)

+ (NSFetchRequest<IMMessage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IMMessage"];
}

@dynamic content;
@dynamic conversationId;
@dynamic createTime;
@dynamic friendId;
@dynamic fromPeerId;
@dynamic messageId;
@dynamic needShowmessageTime;
@dynamic sendFromMe;
@dynamic status;
@dynamic toPeerId;
@dynamic type;
@dynamic updateTime;
@dynamic midiaFile;
@dynamic user;

@end
