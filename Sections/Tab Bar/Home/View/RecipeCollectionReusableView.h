//
//  RecipeCollectionReusableView.h
//  SuGeMarket
//
//  Created by 1860 on 15/10/19.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"


@interface RecipeCollectionReusableView : UICollectionReusableView<UIScrollViewDelegate>
{
    int timeCount;
    UIView *lineView;
    UIView *headerView;
    UIView *qianggouView;
    UIView *zhuantiView;
    MZTimerLabel *qianggou_timer;
    UIPageControl *_pageControl;
    UIPageControl *_pageControl_qianggou;
    NSMutableArray *tagArray;
}
@property (nonatomic,strong) UILabel *qianggou_timer_label;
@property (nonatomic,strong) UIScrollView *_scrollView;
@property (nonatomic,strong) UIScrollView *qianggouScrollView;

@property (nonatomic,strong) UIImageView *qianggou_imageview;
@property (nonatomic,strong) UILabel *qianggou_name;
@property (nonatomic,strong) UILabel *qianggou_price;
@property (nonatomic,strong) UILabel *qianggou_group_price;
@property (nonatomic,strong) UILabel *qianggou_time;

- (void)addValueForReusableView:(NSMutableArray *)value;
- (void)addValueForQianggouView:(NSMutableArray *)value;
- (void)addValueForZhuantiView:(NSMutableArray *)value;
- (void)addTagArray:(NSMutableArray *)tag;
@end
