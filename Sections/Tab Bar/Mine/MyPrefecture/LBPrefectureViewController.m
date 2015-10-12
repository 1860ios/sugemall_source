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

@interface LBPrefectureViewController ()
{
    CAShapeLayer *arcLayer;
    UIView *personView;

}
@end

@implementation LBPrefectureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"会员专区";
    [self initPersonView];
    [self initMiddel];
    
}
#pragma mark  initPersonView

-(void)initPersonView
{
    personView=[[UIView alloc]initWithFrame:CGRectMake(0, 73, SCREEN_WIDTH, 100)];
    personView.backgroundColor=[UIColor colorWithPatternImage:IMAGE(@"背景")];
    [self.view addSubview:personView];
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 70, 70)];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_iconString] placeholderImage:IMAGE(@"user_no_image.png")];
    iconImageView.layer.cornerRadius = 35;
    iconImageView.layer.masksToBounds  = YES;
    [personView addSubview:iconImageView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+10, iconImageView.frame.origin.y-5,SCREEN_WIDTH-iconImageView.frame.size.width-20,35)];
    nameLabel.text=_nameString;
    nameLabel.font=FONT(15);
    [personView addSubview:nameLabel];

    UILabel *pointLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+5,nameLabel.frame.size.width,35)];
    pointLabel.text=_nameString;
    pointLabel.font=FONT(13);
    [personView addSubview:pointLabel];
    
    UIButton *rechargeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rechargeButton.frame=CGRectMake(pointLabel.frame.origin.x, pointLabel.frame.origin.y+pointLabel.frame.size.height+5,100, 35) ;
    [rechargeButton setTitle:@"立即充值" forState:0];
    rechargeButton.backgroundColor=[UIColor redColor];
    [personView addSubview:rechargeButton];
    

}
#pragma mark initMiddel

-(void)initMiddel
{
    CGFloat pading = ([UIScreen mainScreen].applicationFrame.size.width -300)/4.0;
    
    CGFloat viewX = pading;
    LBPrefectureView *preView = [[LBPrefectureView alloc] initWithFrame:CGRectMake(viewX,personView.frame.origin.y+personView.frame.size.height+10,100, 100)];
    //百分比
    //        round.persentNum = 168;
    preView.lineColor = [UIColor redColor];
    preView.progressWidth = 20;
    [self.view addSubview:preView];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(viewX+80,preView.frame.origin.y-10, 2, 60)];
    lineView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:lineView];

    [preView drawLayerAnimation];


}
@end
