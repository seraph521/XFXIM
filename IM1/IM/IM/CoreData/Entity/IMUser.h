//
//  IMUser+CoreDataClass.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IMConversation, IMMessage;

NS_ASSUME_NONNULL_BEGIN

@interface IMUser : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "IMUser+CoreDataProperties.h"
