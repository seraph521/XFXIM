//
//  UIView+Category.m
//  EVA
//
//  Created by Apple on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "UIView+Category.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@implementation UIView (Category)

#pragma mark - UIViewRect

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}


#pragma mark - UIViewLayer

- (void)changeRadius:(CGFloat)aRadius {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:aRadius];
}

- (void)changeBorder:(CGFloat)aBorder withColor:(UIColor *)aColor {
    CGColorRef aColorRef = [aColor CGColor];
    [self.layer setBorderWidth:aBorder];
    [self.layer setBorderColor:aColorRef];
}

#pragma mark - UITableView Cell

- (void)setExtraCellLineHidden {
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tabelView = (UITableView *)self;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [tabelView setTableFooterView:view];
    }
}

- (void)setInsetMarginsZero {
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
#endif
        
    }
}

#pragma mark - 永久闪烁的动画

- (void)addOpacityAnimationWithDuration:(CFTimeInterval)duration opacity:(CGFloat)opacity {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:opacity];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    [self.layer addAnimation:animation forKey:@"OpacityAnimation"];
}

-(UIImage *) glToUIImage
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    int width = (int)size.width;
    int height = (int)size.height;
    
    UIImage * leftTopImage = [self getGLImageWithXOffset:0 yOffset:height];
    UIImage * rightTopImage = [self getGLImageWithXOffset:width yOffset:height];
    UIImage * leftBottomImage = [self getGLImageWithXOffset:0 yOffset:0];
    UIImage * rightBottomImage = [self getGLImageWithXOffset:width yOffset:0];
    
    UIGraphicsBeginImageContext(CGSizeMake(width * 2, height * 2));
    [leftTopImage drawInRect:CGRectMake(0, 0, width, height)];
    [rightTopImage drawInRect:CGRectMake(width, 0, width, height)];
    [leftBottomImage drawInRect:CGRectMake(0, height, width, height)];
    [rightBottomImage drawInRect:CGRectMake(width, height, width, height)];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)getGLImageWithXOffset:(int)xOffset yOffset:(int)yOffset
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    int width = (int)size.width;
    int height = (int)size.height;
    
    NSInteger myDataLength = width * height * 16;  //width-width，height-height
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(xOffset, yOffset, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y <height; y++)
    {
        for(int x = 0; x <width * 4; x++)
        {
            buffer2[(height - 1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    free(buffer);
    
    return myImage;
}

@end
