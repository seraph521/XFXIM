//
//  TMRefreshHeader.h
//  HeaderRefreshDemo
//
//  Created by tommy on 16/6/22.
//  Copyright © 2016年 eva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^RefreshBlock)(void);
typedef NS_ENUM(NSInteger,TMHeaderRefreshingType) {
    kTMHeaderRefreshingTypeIdle = 0,
    kTMHeaderRefreshingTypeRefreshing
};


@interface TMRefreshHeader : NSObject

@property(nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,assign) TMHeaderRefreshingType refreshingType;

+ (instancetype)headerWithRefreshingBlock:(RefreshBlock)refreshBlock;

- (void)attachToScrollView:(UIScrollView *)scrollView;

- (void)endRefreshing;

@end
