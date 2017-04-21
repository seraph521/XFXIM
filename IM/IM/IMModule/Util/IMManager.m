//
//  IMManager.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/19.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMManager.h"

static IMManager * manager;
static NSString * chattingConversationId;

@implementation IMManager

#pragma mark - Singleton
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    
    return manager;
    
}

-(id)copyWithZone:(NSZone *)zone
{
    return manager;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return manager;
}

+ (instancetype)sharedInstance{

    return [[self alloc] init];
}


#pragma mark - lazy load
- (AVIMClient *)imClient{

    if(_imClient == nil){
    
        _imClient = [[AVIMClient alloc]init];
    }
    return _imClient;
}

- (void)startIMClient{

    IMLoginUserModel * userModel = [IMLoginUserModelArchieveTool userInfoUnAchieveFromFile];
    [self.imClient openWithClientId:[NSString stringWithFormat:@"%zd",userModel.uid] callback:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            NSLog(@"=====startClick=succeeded");
        }
    }];
}


- (void)setupChattingConversationId:(NSString *)conversationId
{
    chattingConversationId = conversationId;
}




@end
