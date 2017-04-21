//
//  IMLoginUserModel.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMLoginUserModel.h"

@implementation IMLoginUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeInt:_uid forKey:@"uid"];
    [aCoder encodeObject:_uname forKey:@"uname"];
    [aCoder encodeObject:_avatar forKey:@"avatar"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if(self == [super init]){
    
        self.uid = [aDecoder decodeInt32ForKey:@"uid"];
        self.uname = [aDecoder decodeObjectForKey:@"uname"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
    }
    return self;
}


@end
