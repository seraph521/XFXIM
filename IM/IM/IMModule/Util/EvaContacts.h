//
//  CDContacts.h
//  EVA
//
//  Created by Apple on 15/2/10.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVAContact.h"

@interface EvaContacts : NSObject

+ (void)loadAddressBookContacts;

+ (void)loadAddressBookContacts:(AVArrayResultBlock)block;

+ (NSArray *)getAddressBookContacts;

@end
