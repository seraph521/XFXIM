//
//  IMConversation+CoreDataProperties.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMConversation+CoreDataProperties.h"

@implementation IMConversation (CoreDataProperties)

+ (NSFetchRequest<IMConversation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IMConversation"];
}

@dynamic conversationId;
@dynamic is_shield;
@dynamic lastMessageContent;
@dynamic lastUpdateTime;
@dynamic type;
@dynamic unReadCount;
@dynamic group;
@dynamic user;

@end
