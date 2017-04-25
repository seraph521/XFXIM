//
//  IMUser+CoreDataClass.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/21.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMUser.h"
#import "IMConversation.h"
#import "IMMessage.h"
@implementation IMUser

- (void)setupUserWithInfoDict:(NSDictionary *)infoDict
{
    self.avatar = [infoDict objectForKey:@"avatar"];
    self.nickname = [infoDict objectForKey:@"nickName"];
    self.uid = @([[infoDict valueForKey:@"uid"] longLongValue]);
    self.avatar = [infoDict valueForKey:@"avatar"] ;
}
@end
