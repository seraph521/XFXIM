//
//  IMCoreDataStack.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMCoreDataStack : NSObject

+ (instancetype)sharedInstance;

- (void)initCoreDataComponents;

//重置CoreData组件,更换账号时使用
- (void)resetCoreDataComponents;

@end
