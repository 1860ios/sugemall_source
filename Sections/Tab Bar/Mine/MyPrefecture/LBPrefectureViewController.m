//
//  LBPrefectureViewController.m
//  SuGeMarket
//   会员专区
//  Created by 1860 on 15/10/9.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBPrefectureViewController.h"
#import "LBPrefectureView.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>
#import "LBRechargeViewController.h"
@interface LBPrefectureViewController ()<UIScrollViewDelegate>
{
    CAShapeLayer *arcLayer;
    UIView *personView;
    LBPrefectureView *preView;
    UIImageView *imageView;
    UIImageView *imageView1;
    CGColorRef color;
    CGColorRef color1;
}
@property (nonatomic, strong) UIScrollView *_scrollView;

@end
@implementation LBPrefectureViewController
@synthesize _scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"会员专区";
    [self initScrollView];
    [self initPersonView];
    [self initMiddel];
    [self initUpView];
    NSLog(@"%@",_vipNum);
}
#pragma mark  个人信息
-(void)initPersonView
{
    personView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    personView.backgroundColor=[UIColor colorWithPatternImage:IMAGE(@"background1")];
    [_scrollView addSubview:personView];
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 100, 100)];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_iconString] placeholderImage:IMAGE(@"user_no_image.png")];
    iconImageView.layer.cornerRadius = 52;
    iconImageView.layer.masksToBounds  = YES;
    [personView addSubview:iconImageView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+15, iconImageView.frame.origin.y+5,SCREEN_WIDTH-iconImageView.frame.size.width-20,35)];
    nameLabel.text=_nameString;
    nameLabel.font=FONT(15);
    [personView addSubview:nameLabel];

    UILabel *pointLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height-13,nameLabel.frame.size.width,35)];
    pointLabel.font=FONT(13);
    pointLabel.text=[NSString stringWithFormat:@"积分:%@",_integrationString];
    pointLabel.textColor=[UIColor lightGrayColor];
    [personView addSubview:pointLabel];
    
    UIButton *rechargeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rechargeButton.frame=CGRectMake(pointLabel.frame.origin.x, pointLabel.frame.origin.y+pointLabel.frame.size.height-5,120, 30);
    [rechargeButton setTitle:@"立即充值    >>" forState:0];
    rechargeButton.backgroundColor=[UIColor redColor];
    [rechargeButton addTarget:self action:@selector(pushToRecharge) forControlEvents:UIControlEventTouchUpInside];
    [personView addSubview:rechargeButton];
}
#pragma mark 等级进度条

-(void)initMiddel
{
    preView = [[LBPrefectureView alloc] initWithFrame:CGRectMake(20,personView.frame.origin.y+personView.frame.size.height+40,100, 100)];
    //百分比
    //        round.persentNum = 168;
    preView.lineColor = [UIColor redColor];
    preView.progressWidth = 20;
    preView.vipNum=_vipNum;
    [_scrollView addSubview:preView];

    [preView drawLayerAnimation];
}
#pragma mark initScrollView

-(void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+20);
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
//    _scrollView.pagingEnabled = YES;
//    _scrollView.directionalLockEnabled = YES;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.bounces = NO;
    _scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_scrollView];
}
#pragma mark 等级升级

-(void)initUpView
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, preView.frame.origin.y+preView.frame.size.height, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview:lineView];
    
   imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-125,preView.frame.origin.y+preView.frame.size.height+10, 250, 45)];
    imageView1.image=IMAGE(@"3级_03");
    [_scrollView addSubview:imageView1];
    
    NSArray *array=@[@"vip",@"黄金_02",@"铂金",@"钻石"];
    for (int i=0;i<4; i++) {
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,imageView1.frame.origin.y+imageView1.frame.size.height+i*40 , SCREEN_WIDTH-80, 50)];
        imageView.image=IMAGE(array[i]);
        [_scrollView addSubview:imageView];
    }
    UIButton *upButton=[UIButton buttonWithType:UIButtonTypeSystem];
    upButton.frame=CGRectMake(SCREEN_WIDTH-10-60,imageView1.frame.origin.y+imageView1.frame.size.height+13, 60, 25);
    [upButton setTitle:@"升级" forState:0];
    [upButton setTitleColor:[UIColor greenColor] forState:0];
    [upButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [upButton.layer setBorderWidth:1];//设置边界的宽度
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    color = CGColorCreate(colorSpaceRef, (CGFloat[]){0,1,0,1});
    [upButton.layer setBorderColor:color];
    [upButton addTarget:self action:@selector(pushToRecharge) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:upButton];
    
    UIButton *upButton1=[UIButton buttonWithType:UIButtonTypeSystem];
    upButton1.frame=CGRectMake(SCREEN_WIDTH-10-60,imageView1.frame.origin.y+imageView1.frame.size.height+13+38, 60, 25);
    [upButton1 setTitle:@"升级" forState:0];
    [upButton1 setTitleColor:[UIColor greenColor] forState:0];
    [upButton1.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [upButton1.layer setBorderWidth:1];//设置边界的宽度
    [upButton1.layer setBorderColor:color];
    [upButton1 addTarget:self action:@selector(pushToRecharge) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:upButton1];
    
    UIButton *upButton2=[UIButton buttonWithType:UIButtonTypeSystem];
        upButton2.frame=CGRectMake(SCREEN_WIDTH-10-60,imageView1.frame.origin.y+imageView1.frame.size.height+13+2*38, 60, 25);
        [upButton2 setTitle:@"升级" forState:0];
        [upButton2 setTitleColor:[UIColor greenColor] forState:0];
        [upButton2.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [upButton2.layer setBorderWidth:1];//设置边界的宽度
        [upButton2.layer setBorderColor:color];
        [upButton2 addTarget:self action:@selector(pushToRecharge) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:upButton2];
    color1 =CGColorCreate(colorSpaceRef, (CGFloat[]){0.5,0.5,0.5,1});
    UIButton *upButton3=[UIButton buttonWithType:UIButtonTypeCustom];
    NSInteger a=[_vipNum intValue];
    switch (a) {
        case 168:
            [upButton setTitle:@"已完成" forState:0];
            [upButton setTitleColor:[UIColor lightGrayColor] forState:0];
            [upButton.layer setBorderColor:color1];
            upButton.userInteractionEnabled=NO;
            break;
        case 1000:
            [upButton1 setTitle:@"已完成" forState:0];
            [upButton1 setTitleColor:[UIColor lightGrayColor] forState:0];
            [upButton1.layer setBorderColor:color1];
            upButton1.userInteractionEnabled=NO;
            break;
        case 2000:
            [upButton2 setTitle:@"已完成" forState:0];
            [upButton2 setTitleColor:[UIColor lightGrayColor] forState:0];
            [upButton2.layer setBorderColor:color1];
            upButton2.userInteractionEnabled=NO;
            break;
        case 3000:

           upButton3.frame=CGRectMake(SCREEN_WIDTH-10-60,imageView1.frame.origin.y+imageView1.frame.size.height+13+3*38, 60, 25);
            [upButton3 setTitle:@"已完成" forState:0];
            upButton3.titleLabel.font=FONT(13);
            [upButton3 setTitleColor:[UIColor lightGrayColor] forState:0];
            [upButton3.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
            [upButton3.layer setBorderWidth:1];//设置边界的宽度
            [upButton3.layer setBorderColor:color1];
            [_scrollView addSubview:upButton3];
            break;
        default:
            break;
    }

}
-(void)pushToRecharge
{
    LBRechargeViewController *recharge=[[LBRechargeViewController alloc]init];
    [self.navigationController pushViewController:recharge animated:YES];
}
@end
