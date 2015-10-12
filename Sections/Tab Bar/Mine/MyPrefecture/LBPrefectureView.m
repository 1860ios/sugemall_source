//
//  LBPrefectureView.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/9.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBPrefectureView.h"

@implementation LBPrefectureView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        //        self.backgroundColor = [UIColor brownColor];
        _trackLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.frame = self.bounds;
        _trackLayer.fillColor = [UIColor colorWithWhite:0.97 alpha:0.98].CGColor;
        _trackLayer.strokeColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1].CGColor;
        [self setTrack];
        _progressLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.frame = self.bounds;
        _progressWidth = 5;
        //        _progressLayer.lineCap = kCALineCapRound;//有误差
        _progressLayer.fillColor = [[UIColor clearColor]CGColor];//类似于背景色
        //        _progressLayer.strokeColor = _lineColor.CGColor;//填充色
    }
    return self;
}
- (void)setTextLayer{
    textLayer = [[CATextLayer alloc] init];
    textLayer.frame = CGRectMake(0,0,100,35);
    textLayer.position = CGPointMake(100, 0);//不理解字体偏上。手动调节居中
    textLayer.string=@"168";
    textLayer.foregroundColor=[UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.fontSize = 13;//设置字体、大概的字体，如果超过宽度，会减，后面计算
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:textLayer];
    
}

//layer
- (void)setTrack
{
    _trackLayer.lineWidth = 0;
    UIBezierPath *trackPath=[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 400, 40)];
    _trackLayer.path = trackPath.CGPath;
    
}
//layer
- (void)setProgress
{
    _progressLayer.strokeColor = _lineColor.CGColor;
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath moveToPoint:CGPointMake(0 , 20)];
    [progressPath addLineToPoint:CGPointMake(80, 20)];
    // 将path绘制出来
    [progressPath stroke];
    
    _progressLayer.lineWidth = 40;
    _progressLayer.path = progressPath.CGPath;
    
}



- (void)drawLayerAnimation
{
    [self setTextLayer];
    
    [self setProgress];
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [_progressLayer addAnimation:bas forKey:@"key"];
}

-  (CGSize)textSizeWithText:(NSString *)text andSysFont:(CGFloat)fontSize
{
    UIFont *font= [UIFont systemFontOfSize:fontSize];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(200,200) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:NULL];
    return rect.size;
}



@end
