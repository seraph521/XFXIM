//
//  IMGroup+CoreDataProperties.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/24.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMGroup+CoreDataProperties.h"

@implementation IMGroup (CoreDataProperties)

+ (NSFetchRequest<IMGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IMGroup"];
}

@dynamic conversationId;
@dynamic create_id;
@dynamic favicon;
@dynamic group_description;
@dynamic group_name;
@dynamic groupId;
@dynamic member_count;
@dynamic conversation;

@end
