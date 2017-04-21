//
//  IMConversation+CoreDataClass.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IMGroup, IMUser;

NS_ASSUME_NONNULL_BEGIN

@interface IMConversation : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "IMConversation+CoreDataProperties.h"
