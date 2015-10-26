//
//  LBEndAutAuthenticationViewController.m
//  SuGeMarket/Users/mac/Downloads/10.11日细节页面.rar.download/10.11日细节页面.rar
//
//  Created by 1860 on 15/10/17.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBEndAutAuthenticationViewController.h"
#import "UtilsMacro.h"
static NSString *cid=@"cid";
@interface LBEndAutAuthenticationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *_tableView;
@end

@implementation LBEndAutAuthenticationViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"实名认证";
    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=RGBCOLOR(0, 160, 233);
    [self initTableView];
    [self initHeadView];

}
#pragma mark 上方
-(void)initHeadView
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    headerView.backgroundColor=RGBCOLOR(0, 160, 233);
    UIImageView *renzhengImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-70, 20, 140, 140)];
    renzhengImageView.backgroundColor=[UIColor greenColor];
    renzhengImageView.contentMode = UIViewContentModeScaleAspectFit;
    renzhengImageView.layer.cornerRadius = 70;
    renzhengImageView.layer.masksToBounds  = YES;
    [headerView addSubview:renzhengImageView];
    
    UILabel *banbenLabel=[[UILabel alloc]initWithFrame:CGRectMake(renzhengImageView.frame.origin.x, renzhengImageView.frame.origin.y+renzhengImageView.frame.size.height+10, renzhengImageView.frame.size.width, 30)];
    banbenLabel.text=@"您已通过实名认证";
    banbenLabel.font=FONT(14);
    banbenLabel.textAlignment=NSTextAlignmentCenter;
    banbenLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:banbenLabel];
    
    _tableView.tableHeaderView=headerView;
}

#pragma mark initTableView
-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorInset=UIEdgeInsetsMake(0, -11, 0,11);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}
#pragma mark initTableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cid];
    }
    if (indexPath.section==0&&indexPath.row==0) {
        cell.textLabel.text=@"真实姓名";
        cell.detailTextLabel.text=_name;
    }else if(indexPath.section==0&&indexPath.row==1)
    {
        cell.textLabel.text=@"身份证号";
        cell.detailTextLabel.text=_id;
    }else {
        cell.textLabel.text=@"证件审核";
        cell.detailTextLabel.text=@"已通过";
    }
    return cell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //        self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

@end
