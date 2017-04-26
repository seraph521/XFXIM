//
//  UIView+Category.h
//  EVA
//
//  Created by Apple on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

- (void)changeRadius:(CGFloat)aRadius;
- (void)changeBorder:(CGFloat)aBorder withColor:(UIColor *)aColor;

//    TableView专用
- (void)setExtraCellLineHidden;  //用于隐藏没有数据的Cell
- (void)setInsetMarginsZero;    //调整分隔线15像素的偏移

//    添加闪烁动画
- (void)addOpacityAnimationWithDuration:(CFTimeInterval)duration opacity:(CGFloat)opacity;

-(UIImage *) glToUIImage;

@end
