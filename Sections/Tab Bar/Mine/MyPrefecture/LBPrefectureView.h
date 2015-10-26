//
//  LBPrefectureView.h
//  SuGeMarket
//
//  Created by 1860 on 15/10/9.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBPrefectureView : UIView
{
    CAShapeLayer *_trackLayer,*_progressLayer,*lineLayer,*_progressLayer1;
    CATextLayer *textLayer,*textLayer1;
}

/**
 *  填充线宽度 推荐5
 */
@property (assign,nonatomic) CGFloat progressWidth;
/**
 *  填充线颜色。必设置的
 */
@property (strong,nonatomic) UIColor *lineColor;

@property (nonatomic, assign) NSString *vipNum;

- (void)drawLayerAnimation;
@end
