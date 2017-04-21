//
//  UIImage+Category.h
//  EVA
//
//  Created by Apple on 15/2/3.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define HEADER_IMG_MAX_WIDTH  200
#define HEADER_IMG_MAX_HEIGHT 200

@interface UIImage (Category)

+ (UIImage *)getImageWithImageNamed:(NSString *)imageName;
+ (UIImage *)getPureImageWithColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius;
//对图片切圆角
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
+ (UIImage *)resizeImage:(NSString *)imageName;
//    制作圆形图片
+ (UIImage *)circleImage:(UIImage *)originalImage;
+ (UIImage *)circleImage:(UIImage *)originalImage baseSize:(CGSize)size;

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

//    按照比例缩放图片
+ (UIImage *)scaleImage:(UIImage *)originalImage baseSize:(CGSize)size;

+ (UIImage *)scaleBigImage:(UIImage *)image;
//    获取本地视频的缩略图
+ (UIImage *)imageWithVideoURL:(NSURL *)videoURL;

- (UIImage *)fixOrientation;

//对圆形图片画上边框
+ (UIImage *)addCircleLineToImage:(UIImage *)image withCircleColor:(UIColor *)color withLineWidth:(CGFloat)lineWidth;

//对控件进行截图
+ (UIImage *) captureSubView:(UIView *)view;

//图片合成
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 withRect:(CGRect)imageRect;

+ (UIImage *)clipPartImageFromImage:(UIImage *)image;

- (UIImage *)clipSquarePartImageInScreenWithMarginPercent:(CGFloat)percent andVideoOrientation:(AVCaptureVideoOrientation)videoOrientation;

//根据特定图片宽高比，切出符合比例的图片
- (UIImage *)clipRatioImageWithImageWidthHeightRatio:(CGFloat)ratio;

- (UIImage *)normalizedImage;

/**
 * 将UIColor变换为UIImage
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)blurImage:(UIImage *)image floatBlurLevel:(CGFloat)level;

+ (UIImage *)getImageWithOriginImage:(UIImage *)originImage usingAngle:(CGFloat)angle;
/**
 * UIImage根据方向旋转获得新UIImage
 **/
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

//画边线
+ (UIImage *)drawCircleLineOnImage:(UIImage *)originImage lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor radius:(CGFloat)radius;

//将首文字绘制到底图上
+ (UIImage *)drawFirstLetterWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font onImage:(UIImage *)baseImage;

// 改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)addFilter:(NSString *)filter;

@end
