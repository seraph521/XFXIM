//
//  EvaGrowingTextView.h
//  Yoal
//
//  Created by eva on 15/11/3.
//  Copyright © 2015年 Eva. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EvaGrowingTextViewDelegate <UITextViewDelegate>

@optional
- (void)updateContraintsWithNewHeight:(CGFloat)newHeight;

@end


@interface EvaGrowingTextView : UITextView

@property (nonatomic,assign) CGFloat maxHeight;
@property (nonatomic,assign) BOOL needShowPlaceholder;
@property (nonatomic,copy) NSString * placeholderTitle;
@property (nonatomic,assign) BOOL isManual;


@property (nonatomic,weak) id<EvaGrowingTextViewDelegate> delegate;

- (void)makePlaceholderLabelVisable:(BOOL)needShow;
- (void)manualLayoutSubViews;
@end
