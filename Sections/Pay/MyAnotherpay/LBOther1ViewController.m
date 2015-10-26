//
//  LBOther1ViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/23.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBOther1ViewController.h"
#import "SUGE_API.h"
#import "UtilsMacro.h"
#import "SVProgressHUD.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "LBUserInfo.h"
#import "TSMessage.h"
@interface LBOther1ViewController ()<UIScrollViewDelegate>
{
    UIView *heardView;
}
@property(nonatomic,strong)UIScrollView *_scrollView;
@end

@implementation LBOther1ViewController
@synthesize _scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    self.title=@"找人代付";
    [self initScrollView];
}
-(void)initPersonView
{
    heardView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    heardView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:heardView];
    
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,0,100,100)];
    iconImageView.layer.masksToBounds  = YES;
    iconImageView.backgroundColor=[UIColor redColor];
    [heardView addSubview:iconImageView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+1, iconImageView.frame.origin.y+5,SCREEN_WIDTH-iconImageView.frame.size.width-30,35)];
    nameLabel.font=FONT(15);
    nameLabel.numberOfLines=2;
    nameLabel.text=@"rbverbrtntmnyyumewrthwrhqeg";
    [heardView addSubview:nameLabel];
    
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+10,nameLabel.frame.size.width,35)];
    priceLabel.font=FONT(13);
    priceLabel.textColor=[UIColor lightGrayColor];
    [heardView addSubview:priceLabel];
    
    UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x+priceLabel.frame.size.width, priceLabel.frame.origin.y,priceLabel.frame.size.width,35)];
    numLabel.font=FONT(13);
    numLabel.textColor=[UIColor lightGrayColor];
    [heardView addSubview:numLabel];

}

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

-(void)loadPayDatas
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
    NSDictionary *parameter = @{@"key":key,@"pay_sn":_pay_sn};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    [maneger GET:SUGE_PAYANOTHER1 parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
    }];
    [SVProgressHUD dismiss];
    
}

@end
