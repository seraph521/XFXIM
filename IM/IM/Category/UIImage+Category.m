//
//  UIImage+Category.m
//  EVA
//
//  Created by Apple on 15/2/3.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "UIImage+Category.h"
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>
#import "GPUImage.h"


@implementation UIImage (Category)

+ (UIImage *)imageOriginalWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

+ (UIImage *)getImageWithImageNamed:(NSString *)imageName
{
    if(imageName){
        NSString * imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        if(imagePath){
            return [[UIImage alloc]initWithContentsOfFile:imagePath];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

+ (UIImage *)getPureImageWithColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)getPureImageWithColor:(UIColor *)color inSize:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}

//对图片切圆角
- (UIImage *)imageWithCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    
    [self drawInRect:rect];
    
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}



#pragma mark - CircleImage

+ (UIImage *)resizeImage:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, imageW, 0, imageW) resizingMode:UIImageResizingModeStretch];
}


+ (UIImage *)circleImage:(UIImage *)originalImage {
    // 1.设置圆形的属性（颜色和边框宽度）
    CGFloat borderWidth = 1.0;
    UIColor *borderColor = [UIColor clearColor];
    
    // 2.取得尺寸小得边作为圆形图片的半径
    CGFloat imageW = originalImage.size.width + 2 * borderWidth;
    CGFloat imageH = originalImage.size.height + 2 * borderWidth;
    CGFloat baseRadius = MIN(imageW, imageH);
    CGSize imageSize = CGSizeMake(baseRadius, baseRadius);
    
    // 3.开启上下文，并取得当前的上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen]scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = baseRadius * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [originalImage drawInRect:CGRectMake(borderWidth, borderWidth, originalImage.size.width, originalImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 9.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)circleImage:(UIImage *)originalImage baseSize:(CGSize)size {
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    CGRect drawRect = (CGRect){CGPointZero, size};
    [[UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:size.width / 2] addClip];
    
    // Draw your image
    [originalImage drawInRect:drawRect];
    
    // Get the image, here setting the UIImageView image
    originalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return originalImage;
}

+ (UIImage *)scaleImage:(UIImage *)originalImage baseSize:(CGSize)baseSize {
    
    // 0.最先判断下图片尺寸是否正好适合控件尺寸
    CGSize needSize = (CGSize){baseSize.width, baseSize.height};
    if (CGSizeEqualToSize(originalImage.size, needSize)) {
        return originalImage;
    }
    
    // 1.获取原始图片尺寸
    CGSize imageSize = originalImage.size;
    
    // 2.获取控件尺寸计算新图片等比缩放后的尺寸
    CGSize newSize = CGSizeZero;
    if (baseSize.height > baseSize.width) {
        newSize.height = baseSize.height;
        newSize.width = baseSize.height * imageSize.width / imageSize.height;
    }
    else if (baseSize.height < baseSize.width) {
        newSize.width = baseSize.width;
        newSize.height = baseSize.width *imageSize.height / imageSize.width;
    }
    else {
        if (imageSize.height > imageSize.width) {
            newSize.width = baseSize.width;
            newSize.height = baseSize.width *imageSize.height / imageSize.width;
        }
        else if (imageSize.height < imageSize.width) {
            newSize.height = baseSize.height;
            newSize.width = baseSize.height * imageSize.width / imageSize.height;
        }
    }
    
    // 3.处理下小数（四舍五入）
    CGSize scaleSize = (CGSize){roundf(newSize.width) * 2, roundf(newSize.height) * 2};
    
    // 4.缩放图片到指定尺寸，并获取到缩放后的图片
    UIImage *scaleImage = [UIImage scaleImage:originalImage toSize:scaleSize];
    
    // 5.将缩放后的图片按照控件尺寸进行裁剪
    UIImage *newImage = [UIImage clipImage:scaleImage toSize:needSize];
    
    // 6.返回最终图片
    return newImage;
}

#pragma mark - ScaleImage

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    // 创建一个bitmap的context// 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen]scale]);
    
    // 绘制改变大小的图片
    [image drawInRect:(CGRect){CGPointZero, size}];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return resultImage;
}


+ (UIImage *)clipPartImageFromImage:(UIImage *)image
{
    CGFloat imageWidth = image.size.width;
    CGFloat sourceHeight = image.size.height;
    CGFloat imageHeight = imageWidth * (9.0 / 16);
    CGFloat margin = (sourceHeight - imageHeight) * 0.5;
    CGRect partRect = CGRectMake(0, margin * image.scale, imageWidth * image.scale, imageHeight * image.scale);
    
    CGImageRef imageRef = image.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    imagePartRef = nil;
    image = nil;
    return retImg;
}


- (UIImage *)clipSquarePartImageInScreenWithMarginPercent:(CGFloat)percent andVideoOrientation:(AVCaptureVideoOrientation)videoOrientation
{
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGRect resultRect;
    if(imageWidth == imageHeight){
        return self;
    }else{
        switch (videoOrientation) {
            case AVCaptureVideoOrientationPortrait:{
                //垂直方向手持手机，home键在下
                resultRect = CGRectMake(0, percent * (imageHeight - imageWidth) * self.scale, imageWidth * self.scale, imageWidth * self.scale);
                break;
            }
            case AVCaptureVideoOrientationPortraitUpsideDown:{
                //垂直方向手持手机，home键在上，保持与上相同的切割
                resultRect = CGRectMake(0, (1 - percent) * (imageHeight - imageWidth) * self.scale, imageWidth * self.scale, imageWidth * self.scale);
                break;
            }
            case AVCaptureVideoOrientationLandscapeRight:{
                //水平方向手持手机，home键在右
                resultRect = CGRectMake(percent * (imageWidth - imageHeight) * self.scale, 0, imageHeight * self.scale, imageHeight * self.scale);
                break;
            }
            case AVCaptureVideoOrientationLandscapeLeft:{
                //水平方向手持手机，home键在右
                resultRect = CGRectMake((imageWidth - imageHeight) * (1 - percent) * self.scale, 0, imageHeight * self.scale, imageHeight * self.scale);
                break;
            }
            default:
                break;
        }
        CGImageRef imageRef = self.CGImage;
        CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, resultRect);
        UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
        CGImageRelease(imagePartRef);
        imagePartRef = nil;
        return retImg;
    }
}


- (UIImage *)clipRatioImageWithImageWidthHeightRatio:(CGFloat)ratio
{
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat persent = (imageHeight - imageWidth / ratio) * 0.5 / imageHeight;
    CGRect resultRect = CGRectMake(0, persent * imageHeight * self.scale, imageWidth * self.scale, imageWidth * self.scale / ratio);
    
    CGImageRef imageRef = self.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, resultRect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    imagePartRef = nil;
    return retImg;
}


+ (UIImage *)scaleBigImage:(UIImage *)image
{
    int h = image.size.height;
    int w = image.size.width;
    if(!(h <= 750 && w <= 1334)){
        float b = (float)750/w < (float)1334/h ? (float)750/w : (float)1334/h;
        
        CGSize itemSize = CGSizeMake(b*w, b*h);
        
        UIGraphicsBeginImageContext(itemSize);
        
        CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
        
        [image drawInRect:imageRect];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return image;
}


+ (UIImage *)clipImage:(UIImage *)image toSize:(CGSize)size {
    CGFloat locationX = fabs((image.size.width - size.width) / 2);
    CGFloat locationY = fabs((image.size.height - size.height) / 2);
    CGPoint location = (CGPoint){locationX, locationY};
    CGRect clipRect = (CGRect){location, size};
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, clipRect);
    UIGraphicsBeginImageContext(clipRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, (CGRect){CGPointZero, size}, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    subImageRef = nil;
    return newImage;
}

+ (UIImage *)imageWithVideoURL:(NSURL *)videoURL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    NSError *error = nil;
    CGImageRef image = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    UIImage * returnImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    image = nil;
    return returnImage;
}


- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+ (UIImage *)addPureColoeImageToImage:(UIImage *)baseImage{
    UIGraphicsBeginImageContext(baseImage.size);
    // Draw image1
    [baseImage drawInRect:CGRectMake(0, 0, baseImage.size.width, baseImage.size.height)];
//    UIImage * colorImage = [self getPureImageWithColor:[UIColor colorWithR:255 G:242 B:0 A:0.01] inSize:baseImage.size];
//    [colorImage drawInRect:CGRectMake(0, 0, colorImage.size.width, colorImage.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


+ (UIImage *) captureSubView:(UIView *)view {
    CGRect rect = [view bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen]scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}




+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContextWithOptions(image2.size, NO, [[UIScreen mainScreen]scale]);
    
    // Draw image1
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    // Draw image2
    [image1 drawInRect:CGRectMake((image2.size.width - image1.size.width) * 0.5, (image2.size.height - image1.size.height) * 0.5, image1.size.width, image1.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 withRect:(CGRect)imageRect
{
    UIGraphicsBeginImageContextWithOptions(image2.size, NO, [[UIScreen mainScreen]scale]);
    
    // Draw image1
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    // Draw image2
    [image1 drawInRect:CGRectMake(imageRect.origin.x * image1.scale, imageRect.origin.y * image1.scale, imageRect.size.width * image1.scale, imageRect.size.height * image1.scale)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp){
        return self;
    }
    NSLog(@"%@__%d",NSStringFromCGSize(self.size),(int)self.imageOrientation);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

+ (UIImage *)addCircleLineToImage:(UIImage *)image withCircleColor:(UIColor *)color withLineWidth:(CGFloat)lineWidth
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(image.size.width * 0.5, image.size.height * 0.5) radius:image.size.width * 0.5 - lineWidth * 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [path setLineWidth:lineWidth];
    [color setStroke];
    [path stroke];
    
    [image drawInRect:CGRectMake(lineWidth, lineWidth, image.size.width - lineWidth * 2, image.size.height - lineWidth * 2)];
    
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

/**
 * 将UIColor变换为UIImage
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return theImage;
}



+ (UIImage *)blurImage:(UIImage *)image floatBlurLevel:(CGFloat)level
{
    UIImage * resultImage;
    if(image){
        GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        blurFilter.blurRadiusInPixels = level;
        resultImage = [blurFilter imageByFilteringImage:image];
    }
    return resultImage?resultImage:image;
//    return image;
}

/**
 * UIImage根据方向旋转获得新UIImage
 **/
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

+ (UIImage *)getImageWithOriginImage:(UIImage *)originImage usingAngle:(CGFloat)angle
{
    CGSize originImageSize = originImage.size;
    CGFloat rotate =  - angle * M_PI / 180;
    
    UIGraphicsBeginImageContextWithOptions(originImageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextRotateCTM(context, rotate);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, originImageSize.width, originImageSize.height), originImage.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newPic;
}

+ (UIImage *)drawCircleLineOnImage:(UIImage *)originImage lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor radius:(CGFloat)radius
{
    CGSize originImageSize = originImage.size;
    UIGraphicsBeginImageContextWithOptions(originImageSize, NO, [UIScreen mainScreen].scale);
    [originImage drawInRect:CGRectMake(0, 0, originImageSize.width, originImageSize.height)];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path setLineWidth:lineWidth];
    [path addArcWithCenter:CGPointMake(originImageSize.width * 0.5, originImageSize.height * 0.5) radius:radius - lineWidth * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [lineColor setStroke];
    [path stroke];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

+ (UIImage *)drawFirstLetterWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font onImage:(UIImage *)baseImage
{
    CGSize originImageSize = baseImage.size;
    
    UIGraphicsBeginImageContextWithOptions(originImageSize, NO, [UIScreen mainScreen].scale);
    
    //将底图绘制到上下文中
    [baseImage drawInRect:CGRectMake(0, 0, originImageSize.width, originImageSize.height)];
    
    NSMutableAttributedString * textStr = [[NSMutableAttributedString alloc] initWithString:text];
    [textStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 1)];
    [textStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, 1)];
    
   // CGSize textSize = [text sizeWithFont:[UIFont systemFontSize:24]];
    
   // [textStr drawInRect:CGRectMake((originImageSize.width - textSize.width) * 0.5, (originImageSize.height - textSize.height) * 0.5, textSize.width, textSize.height)];
    
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage *)addFilter:(NSString *)filterName
{
    //将UIImage转换成CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //已有的值不变，其他的设为默认值
    [filter setDefaults];
    
    //获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    
    //创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //获取图片
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    //释放CGImage句柄
    CGImageRelease(cgImage);
    
    return image;
}
@end
