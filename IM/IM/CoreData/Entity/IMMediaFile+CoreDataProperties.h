//
//  IMMediaFile+CoreDataProperties.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMMediaFile.h"


NS_ASSUME_NONNULL_BEGIN

@interface IMMediaFile (CoreDataProperties)

+ (NSFetchRequest<IMMediaFile *> *)fetchRequest;

@property (nonatomic) int16_t duration;
@property (nonatomic) double latitude;
@property (nullable, nonatomic, copy) NSString *local_source_url;
@property (nonatomic) double longitude;
@property (nonatomic) int16_t type;
@property (nullable, nonatomic, copy) NSString *local_thumbnail_url;
@property (nullable, nonatomic, copy) NSString *remote_source_url;
@property (nullable, nonatomic, copy) NSString *remote_thumbnail_url;
@property (nullable, nonatomic, retain) IMMessage *message;

@end

NS_ASSUME_NONNULL_END
