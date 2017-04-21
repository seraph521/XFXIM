//
//  IMUser+CoreDataProperties.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMUser.h"

@implementation IMUser (CoreDataProperties)

+ (NSFetchRequest<IMUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IMUser"];
}

@dynamic avatar;
@dynamic gender;
@dynamic nickname;
@dynamic sign;
@dynamic uid;
@dynamic conversation;
@dynamic messages;

@end