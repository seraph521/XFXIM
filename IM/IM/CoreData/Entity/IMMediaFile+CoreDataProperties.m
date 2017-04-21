//
//  IMMediaFile+CoreDataProperties.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMMediaFile+CoreDataProperties.h"

@implementation IMMediaFile (CoreDataProperties)

+ (NSFetchRequest<IMMediaFile *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IMMediaFile"];
}

@dynamic duration;
@dynamic latitude;
@dynamic local_source_url;
@dynamic longitude;
@dynamic type;
@dynamic local_thumbnail_url;
@dynamic remote_source_url;
@dynamic remote_thumbnail_url;
@dynamic message;

@end
