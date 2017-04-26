//
//  BlurBgActionSheetView.h
//  IM
//
//  Created by LT-MacbookPro on 17/4/26.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlurBgActionSheetView;

@protocol BlurBgActionSheetViewDelegate <NSObject>

@optional
- (void)actionSheetView:(BlurBgActionSheetView *)actionSheet clickButtonAtIndex:(NSInteger)index;

@end

@interface BlurBgActionSheetView : UIView

@property (nonatomic,weak) id<BlurBgActionSheetViewDelegate> delegate;

- (instancetype) initWithBlurImage:(UIImage *) blurImage cancelButtonTitle:(NSString *) cancelButtonTitle otherButtontitles :(NSArray *) otherButtontitles;
- (void)show;
- (void)hide;

@end
