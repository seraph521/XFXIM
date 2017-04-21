//
//  UIView+LayoutFit.m
//  Dream
//
//  Created by eva on 16/2/2.
//  Copyright © 2016年 Eva. All rights reserved.
//

#import "UIView+LayoutFit.h"

//基准宽度值，根据这个宽度值去适配不同屏幕下合理的宽度值
#define TARGET_BASE_SIZE 375.0

@implementation UIView (LayoutFit)

//依据iPhone5的尺寸得到当前屏幕相对于iPhone5屏幕尺寸的大小
+ (CGFloat)lf_sizeFromIphone6:(CGFloat)size{
    static float width = 0;
    if (width == 0) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    
    //保持6和6p显示大小相同
    if(width >= 414){
        width = 375;
    }
    
    return width / TARGET_BASE_SIZE * size;
}

//依据真实的尺寸得到iPhone5屏幕尺寸的大小
+(CGFloat)lf_sizeFromRealSize:(CGFloat)size{
    static float width = 0;
    if (width == 0) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    
    //保持6和6p显示大小相同
    if(width >= 414){
        width = 375;
    }
    
    return TARGET_BASE_SIZE / width * size;
}

//根据iPhone5的尺寸获得指定宽度相对于iPhone5屏幕尺寸的正方形size
+(CGSize)lf_rectSizeFromIphone6:(CGFloat)size
{
    static float width = 0;
    if (width == 0) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    
    //保持6和6p显示大小相同
    if(width >= 414){
        width = 375;
    }
    
    return CGSizeMake(width / TARGET_BASE_SIZE * size, width / TARGET_BASE_SIZE * size);
}

@end
