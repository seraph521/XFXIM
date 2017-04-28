//
//  EVAContact.m
//  EVA
//
//  Created by Apple on 15/2/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "EVAContact.h"

@implementation EVAContact

@synthesize firstName;
@synthesize lastName;
@synthesize phoneNumber;

- (NSString *)fullName {
    if (self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@%@", self.lastName, self.firstName];
    }
    else if (self.lastName) {
        return self.lastName;
    }
    else if (self.firstName) {
        return self.firstName;
    }
    else if (self.phoneNumber) {
        return self.phoneNumber;
    }
    else {
        return @"";
    }
}

@end
