//
//  IMMediaFile+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/24.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMMediaFile.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMMediaFile (CoreDataProperties)

+ (NSFetchRequest<IMMediaFile *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *duration;
@property (nullable, nonatomic, copy) NSNumber *latitude;
@property (nullable, nonatomic, copy) NSString *local_source_url;
@property (nullable, nonatomic, copy) NSString *local_thumbnail_url;
@property (nullable, nonatomic, copy) NSNumber *longitude;
@property (nullable, nonatomic, copy) NSString *remote_source_url;
@property (nullable, nonatomic, copy) NSString *remote_thumbnail_url;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, retain) IMMessage *message;

@end

NS_ASSUME_NONNULL_END
