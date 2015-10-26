//
//  LBPrefectureView.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/9.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBPrefectureView.h"
#import "UtilsMacro.h"
#import "LBPrefectureViewController.h"
@implementation LBPrefectureView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        //        self.backgroundColor = [UIColor brownColor];
        _trackLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_trackLayer];
//        _trackLayer.frame = CGRectMake(20, 0, 200, 40);
        _trackLayer.fillColor = [UIColor colorWithWhite:0.97 alpha:0.98].CGColor;
        _trackLayer.strokeColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1].CGColor;
        for (int i = 0; i < 4; i++) {
        lineLayer= [[CAShapeLayer alloc] init];
        lineLayer.fillColor = [UIColor colorWithWhite:0.85 alpha:0.85].CGColor;
        lineLayer.strokeColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1].CGColor;
            lineLayer.frame = CGRectMake(i*(SCREEN_WIDTH-60)/4+(SCREEN_WIDTH-60)/4,-5,5,50);
        //        lineLayer.backgroundColor=[UIColor grayColor].CGColor;
            [self.layer addSublayer:lineLayer];
            
            lineLayer.lineWidth=0;
            UIBezierPath *trackPath1=[UIBezierPath bezierPathWithRect:CGRectMake(0,10, 4, 50)];
            lineLayer.path = trackPath1.CGPath;
        }
        [self setTrack];
        _progressLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.frame = self.bounds;
        _progressWidth = 5;
        //        _progressLayer.lineCap = kCALineCapRound;//有误差
        _progressLayer.fillColor = [[UIColor clearColor]CGColor];//类似于背景色
        //        _progressLayer.strokeColor = _lineColor.CGColor;//填充色
        
        _progressLayer1 = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_progressLayer1];
        _progressLayer1.frame = self.bounds;
        _progressWidth = 5;
        //        _progressLayer.lineCap = kCALineCapRound;//有误差
        _progressLayer1.fillColor = [[UIColor clearColor]CGColor];//类似于背景色
        //        _progressLayer.strokeColor = _lineColor.CGColor;//填充色

    }
    return self;
}
- (void)setTextLayer{
    NSArray *array=@[@"普通会员",@"vip会员",@"黄金会员",@"白金会员",@"钻石会员"];
    NSArray *array1=@[@"0元",@"168元",@"1000元",@"2000元",@"3000元"];
    for (int i = 0; i < 5; i++) {
        textLayer = [[CATextLayer alloc] init];
        textLayer.frame = CGRectMake(i*(SCREEN_WIDTH-60)/4+5,0,50,35);
        textLayer.position = CGPointMake(i*(SCREEN_WIDTH-60)/4+5, 0);//不理解字体偏上。手动调节居中
        textLayer.string=array[i];
        textLayer.foregroundColor=[UIColor blackColor].CGColor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.fontSize = 13;//设置字体、大概的字体，如果超过宽度，会减，后面计算
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:textLayer];
        textLayer = [[CATextLayer alloc] init];
        textLayer.frame = CGRectMake(i*(SCREEN_WIDTH-60)/4,80,50,35);
        textLayer.position = CGPointMake(i*(SCREEN_WIDTH-60)/4, 80);//不理解字体偏上。手动调节居中
        textLayer.string=array1[i];
        textLayer.foregroundColor=[UIColor blackColor].CGColor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.fontSize = 13;//设置字体、大概的字体，如果超过宽度，会减，后面计算
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:textLayer];
    }
}

//layer
- (void)setTrack
{
    _trackLayer.lineWidth = 0;
    UIBezierPath *trackPath=[UIBezierPath bezierPathWithRect:CGRectMake(0, 10, SCREEN_WIDTH-60, 40)];
    _trackLayer.path = trackPath.CGPath;
 }
//layer
- (void)setProgress
{
    NSInteger i=[_vipNum intValue];

    _progressLayer.strokeColor = _lineColor.CGColor;
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath moveToPoint:CGPointMake(0 , 30)];
    switch (i) {
        case 168:
            [progressPath addLineToPoint:CGPointMake((SCREEN_WIDTH-60)/4, 30)];
//            _progressLayer.speed=1;
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progessTimer) userInfo:nil repeats:YES];
            break;
        case 1000:
            [progressPath addLineToPoint:CGPointMake((SCREEN_WIDTH-60)/4*2, 30)];
//            _progressLayer.speed=2;
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progessTimer) userInfo:nil repeats:YES];
            break;
        case 2000:
            [progressPath addLineToPoint:CGPointMake((SCREEN_WIDTH-60)/4*3, 30)];
//            _progressLayer.speed=3;
            break;
        case 3000:
            [progressPath addLineToPoint:CGPointMake((SCREEN_WIDTH-60)/4*4, 30)];
            _progressLayer.speed=0.5;
            [NSTimer scheduledTimerWithTimeInterval:2.1  target:self selector:@selector(progessTimer) userInfo:nil repeats:YES];
            break;
        default:
            break;
    }
       // 将path绘制出来
    [progressPath stroke];
    _progressLayer.lineWidth = 40;
    _progressLayer.path = progressPath.CGPath;
}
-(void)progessTimer
{
    [self setProgress1];
}
-(void)setProgress1
{
    NSInteger i;
    if (!_vipNum) {
           i =[_vipNum intValue];
    }
    _progressLayer1.strokeColor = _lineColor.CGColor;
    UIBezierPath *progressPath1 = [UIBezierPath bezierPath];
    switch (i) {
        case 168:
            [progressPath1 moveToPoint:CGPointMake((SCREEN_WIDTH-60)/4, 30)];
            [progressPath1 addLineToPoint:CGPointMake((SCREEN_WIDTH-60)/4+5, 30)];
            break;
        case 1000:
            [progressPath1 moveToPoint:CGPointMake((SCREEN_WIDTH-60)/4*2, 30)];
            [progressPath1 addLineToPoint:CGPointMake((SCREEN_WIDTH-60)/4*2+5, 30)];
            break;
        case 2000:
            [progressPath1 moveToPoint:CGPointMake((SCREEN_WIDTH-60)/4*3, 30)];
            [progressPath1 addLineToPoint:CGPointMake((SCREEN_WIDTH-60)/4*3+5, 30)];
            break;
        case 3000:
            [progressPath1 moveToPoint:CGPointMake((SCREEN_WIDTH-60)/4*4, 30)];
            [progressPath1 addLineToPoint:CGPointMake((SCREEN_WIDTH-60)/4*4+5, 30)];
            break;
        default:
            break;
    }
    // 将path绘制出来
    [progressPath1 stroke];
    _progressLayer1.lineWidth = 50;
    _progressLayer1.path = progressPath1.CGPath;
//      _progressLayer1.speed=1.0;
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
    [_progressLayer1 addAnimation:bas forKey:@"key1"];
}

-  (CGSize)textSizeWithText:(NSString *)text andSysFont:(CGFloat)fontSize
{
    UIFont *font= [UIFont systemFontOfSize:fontSize];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(200,200) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:NULL];
    return rect.size;
}



@end
