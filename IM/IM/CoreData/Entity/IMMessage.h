//
//  IMMessage+CoreDataClass.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IMMediaFile, IMUser;

NS_ASSUME_NONNULL_BEGIN

@interface IMMessage : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "IMMessage+CoreDataProperties.h"
