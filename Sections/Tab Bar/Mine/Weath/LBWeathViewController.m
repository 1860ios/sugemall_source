//
//  LBWeathViewController.m
//  SuGeMarket
//
//  Created by Apple on 15/9/30.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBWeathViewController.h"
#import "UtilsMacro.h"
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import <AFNetworking.h>
#import <UILabel+FlickerNumber.h>

static NSString *collectionCell=@"collectionCell";
@interface LBWeathViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UILabel *numLabel;
    UILabel *numLabel1;
    UILabel *numLabel2;
    NSDictionary *weathDictionary;
    NSArray *numArray;
    NSString *num1;
    NSString *num2;
    NSString *num3;
    NSString *num4;
    NSString *num5;
    NSString *num6;
}
@property (nonatomic, strong) UICollectionView *weathCollectionView;
@end
@implementation LBWeathViewController
@synthesize weathCollectionView;
-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.97];
    self.title=@"财富";
    [self loadData];
    [self initTopView];
    [self initCollectionView];
}
#pragma mark  获取数据
-(void)loadData
{
   // numArray=nil;
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter=@{@"key":key};
    [manager POST:SUGE_WEATH parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"财富%@",responseObject);
        weathDictionary=responseObject[@"datas"];
        num1=weathDictionary[@"points"][@"available"];
        num2=weathDictionary[@"predepoit"][@"p1"];
        num3=weathDictionary[@"predepoit"][@"p2"];
        num4=weathDictionary[@"rc"][@"available"];
        num5=weathDictionary[@"predepoit"][@"p0"];
        numArray=@[num1,num2,num3,num4,num5,@"0.00"];
        NSString *numString = weathDictionary[@"sum"];
//        numLabel.text = numString;
        numLabel1.text=weathDictionary[@"predepoit"][@"available"];
        [numLabel dd_setNumber:[NSNumber numberWithDouble:[numString doubleValue]] duration:2];
        [weathCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
#pragma mark  初始化TopView
-(void)initTopView
{
    UIView *incomeView=[[UIView alloc]initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 110)];
    incomeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:incomeView];
    
    UILabel *incomeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 110, 35)];
    incomeLabel.text=@"累计收益(元)";
    incomeLabel.font=FONT(18);
    incomeLabel.textAlignment=NSTextAlignmentLeft;
    [incomeView addSubview:incomeLabel];
    
    numLabel=[[UILabel alloc]initWithFrame:CGRectMake(incomeLabel.frame.origin.x, incomeLabel.frame.origin.y+incomeLabel.frame.size.height+10, SCREEN_WIDTH, 40)];
    numLabel.font=FONT(40);
    numLabel.textAlignment=NSTextAlignmentLeft;
    numLabel.textColor=[UIColor redColor];
    [incomeView addSubview:numLabel];
    
    UIButton *jiantouButton=[UIButton buttonWithType:UIButtonTypeCustom];
    jiantouButton.frame=CGRectMake(SCREEN_WIDTH-30, incomeLabel.frame.origin.y+5, 20, 20);
    [jiantouButton setImage:IMAGE(@"财富_07") forState:0];
    [incomeView addSubview:jiantouButton];
    
    UILabel *billLabel=[[UILabel alloc]initWithFrame:CGRectMake(jiantouButton.frame.origin.x-30, jiantouButton.frame.origin.y, 40, 20)];
    billLabel.text=@"账单";
    billLabel.font=FONT(12);
    billLabel.textColor=[UIColor grayColor];
    [incomeView addSubview:billLabel];
    
    UILabel *comLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, incomeView.frame.origin.y+incomeView.frame.size.height,110, 35)];
    comLabel.text=@"可提现佣金(元)";
    comLabel.textAlignment=NSTextAlignmentLeft;
    comLabel.font=FONT(15);
    comLabel.textColor=[UIColor lightGrayColor];
    [self.view addSubview:comLabel];
    
    numLabel1=[[UILabel alloc]initWithFrame:CGRectMake(comLabel.frame.origin.x, comLabel.frame.origin.y+comLabel.frame.size.height-10,100, 35)];
    numLabel1.font=FONT(20);
    numLabel1.textColor=RGBCOLOR(9, 234, 242);
    [self.view addSubview:numLabel1];
}
#pragma mark  初始化CollectionView
-(void)initCollectionView
{
    UICollectionViewFlowLayout *layOut=[[UICollectionViewFlowLayout alloc]init];
    weathCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, numLabel1.frame.origin.y+numLabel1.frame.size.height, SCREEN_WIDTH, 180) collectionViewLayout:layOut];
    weathCollectionView.backgroundColor=[UIColor whiteColor];
    weathCollectionView.delegate=self;
    weathCollectionView.dataSource=self;
    weathCollectionView.scrollEnabled=NO;
    [weathCollectionView registerClass:[UICollectionViewCell class]  forCellWithReuseIdentifier:collectionCell];
    [self.view addSubview:weathCollectionView];
    
    UIButton *tixianButton=[UIButton buttonWithType:UIButtonTypeCustom];
    tixianButton.frame=CGRectMake(10, weathCollectionView.frame.origin.y+weathCollectionView.frame.size.height+10, SCREEN_WIDTH-20, 50);
    [tixianButton setImage:IMAGE(@"yue") forState:0];
    [self.view addSubview:tixianButton];

}
#pragma mark  CollectionView代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject]) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    NSArray *array=@[@"积分(元)",@"提现中(元)",@"已提现(元)",@"储值佣金(元)",@"储值金额(元)",@"直接收款(元)"];
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(-15, 10, 100, 35)];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+20,nameLabel.frame.origin.y+10, 2, 50)];
    if (indexPath.row>=3&&indexPath.row<=5) {
        lineView=[[UIView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+20,0, 2, 50)];
    }
    lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.97];
    if (indexPath.row==2||indexPath.row==5) {
        lineView.backgroundColor=[UIColor whiteColor];
    }
    [cell.contentView addSubview:lineView];
    
    if (indexPath.row>=3&&indexPath.row<=5) {
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(-11, -10, 100, 35)];
    }
    nameLabel.font=FONT(13);
    nameLabel.textColor=[UIColor lightGrayColor];
    nameLabel.text=array[indexPath.row];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:nameLabel];
    
    numLabel2=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.center.x-50, nameLabel.frame.origin.y+nameLabel.frame.size.height, nameLabel.frame.size.width, 35)];
    numLabel2.font=FONT(15);
    if (indexPath.row==0) {
        numLabel2.textColor=RGBCOLOR(9, 234, 242);
    }else if(indexPath.row==2)
    {
        numLabel2.textColor=[UIColor redColor];
    }else{
        numLabel2.textColor=[UIColor blackColor];
    }
    numLabel2.text=numArray[indexPath.row];
    numLabel2.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:numLabel2];
    
    UIView *longLineView=[[UIView alloc]initWithFrame:CGRectMake(0,numLabel2.frame.origin.y+numLabel2.frame.size.height+10,SCREEN_WIDTH, 2)];
    longLineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.97];
    [cell.contentView addSubview:longLineView];

    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,2 ,0 ,2 );
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/3-35,100);
}
@end
