//
//  TMRefreshHeader.m
//  HeaderRefreshDemo
//
//  Created by tommy on 16/6/22.
//  Copyright © 2016年 eva. All rights reserved.
//

#import "TMRefreshHeader.h"

@interface TMRefreshHeader () {
    CGFloat headerViewHeight;
}

@property (nonatomic,strong) UIView * refreshingHeaderView;

@property (nonatomic,copy) RefreshBlock refreshingBlock;

@property (nonatomic,assign) BOOL isRefreshing;

@end

@implementation TMRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(RefreshBlock)refreshBlock
{
    TMRefreshHeader * header = [[self alloc] init];
    header.refreshingBlock = refreshBlock;
    header.refreshingType = kTMHeaderRefreshingTypeIdle;
    return header;
}

- (void)attachToScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    headerViewHeight = 40;
    
    self.refreshingType = kTMHeaderRefreshingTypeIdle;
    
    self.refreshingHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, - headerViewHeight, SCREEN_WIDTH, headerViewHeight)];
    self.refreshingHeaderView.backgroundColor = [UIColor clearColor];
    
    UIActivityIndicatorView  * indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = CGRectMake((SCREEN_WIDTH - indicatorView.bounds.size.width) * 0.5, (headerViewHeight - indicatorView.bounds.size.height) * 0.5, indicatorView.bounds.size.width, indicatorView.bounds.size.height);
    [indicatorView startAnimating];
    [self.refreshingHeaderView addSubview:indicatorView];
    
    [_scrollView addSubview:self.refreshingHeaderView];
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"]){
        CGFloat currentOffsetY = [[change valueForKey:@"new"] CGPointValue].y;
        CGFloat lastOffsetY = [[change valueForKey:@"old"] CGPointValue].y;
        
        // 判断是否在拖动_scrollView
        if (self.scrollView.dragging) {
            // 判断是否正在刷新  否则不做任何操作
            if (!self.isRefreshing) {
                if(currentOffsetY - lastOffsetY <= 0){
                    if(fabs(currentOffsetY) > headerViewHeight * 1.5){
                        self.refreshingType = kTMHeaderRefreshingTypeRefreshing;
                    }
                }
            }
        }else if(currentOffsetY < 0){
            // 进入刷新状态
            if (self.refreshingType == kTMHeaderRefreshingTypeRefreshing) {
                [self beiginRefreshing];
            }
        }
    }
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)beiginRefreshing
{
    if (!self.isRefreshing) {
        self.isRefreshing=YES;
        
        // 设置刷新状态_scrollView的位置
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentOffset=CGPointMake(0, -headerViewHeight);
            _scrollView.contentInset=UIEdgeInsetsMake(headerViewHeight, 0, 0, 0);
        }];
        
        // block回调
        self.refreshingBlock();
    }
}

- (void)endRefreshing
{
    self.isRefreshing = NO;
    self.refreshingType = kTMHeaderRefreshingTypeIdle;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_scrollView.contentOffset.y <= headerViewHeight){
            [UIView animateWithDuration:0.3 animations:^{
                _scrollView.contentOffset=CGPointZero;
                _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        }else{
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
        }
    });
}

@end
