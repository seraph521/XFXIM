//
//  EVAContact.h
//  EVA
//
//  Created by Apple on 15/2/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVAContact : NSObject

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *fullName;
@property (copy, nonatomic) NSString *phoneNumber;

@property (nonatomic,assign) BOOL isSelected;

@end
