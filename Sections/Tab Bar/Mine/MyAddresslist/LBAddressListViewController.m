//
//  LBAddressListViewController.m
//  SuGeMarket
//
//  Created by Apple on 15/10/18.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBAddressListViewController.h"
#import "LBInviteViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "TSMessage.h"
#import <MJRefresh.h>
#import "LBPartnerViewController.h"
#import "LBCustomViewController.h"
#import "LBAdvViewController.h"

static NSString *cid=@"cid";
@interface LBAddressListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSDictionary *dictionary;
    NSDictionary *dictionary1;

    NSMutableArray *customArray;
    NSMutableArray *DatasArray;
    int _curpage;
    NSArray *imageArray;
    NSArray *nameArray;
    NSArray *counyArray;
}
@property(nonatomic,strong)UITableView *addTableView;
@end
@implementation LBAddressListViewController
@synthesize addTableView;
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"通讯录";
    imageArray = @[@"通讯录_03",@"通讯录_06"];
    nameArray = @[@"我的合伙人",@"我的客户"];
    counyArray = @[@"partner",@"custom"];
    _curpage=1;
    DatasArray= [NSMutableArray array];
    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"invite_partner") style:UIBarButtonItemStylePlain target:self action:@selector(invitePartner)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"排行榜" style:UIBarButtonItemStyleDone target:self action:@selector(pushRankingList)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItems = @[leftButton];
    [self loadAddressDatas];
    [self initTableView];
    [self addBottomButton];
}

- (void)addBottomButton
{
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(15,SCREEN_HEIGHT-10-50, SCREEN_WIDTH-30, 50);
    [bottomButton setTitle:@"邀请合伙人" forState:UIControlStateNormal];
    [bottomButton setBackgroundColor:APP_COLOR];
    bottomButton.layer.cornerRadius = 3;
    bottomButton.layer.masksToBounds = YES;
    [bottomButton addTarget:self action:@selector(invitePartner) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
}
#pragma mark 排行榜
-(void)pushRankingList
{
    LBAdvViewController *adv = [[LBAdvViewController alloc] init];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSString *url = [NSString stringWithFormat:@"http://test.sugemall.com/wap/tmpl/member/team_rank.html?key=%@",key];
    adv.advURL =url;
    adv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adv animated:YES];
}
#pragma mark initTableView
-(void)initTableView
{
    addTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStylePlain];
    addTableView.delegate=self;
    addTableView.dataSource=self;
    addTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    addTableView.separatorColor = [UIColor redColor];
    addTableView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    addTableView.tableHeaderView = [UIView new];
    [self.view addSubview:addTableView];
}
#pragma mark 获取数据
-(void)loadAddressDatas
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    NSDictionary *parameter=@{@"key":key,@"pagesize":@"5",@"curpage":@"1"};
    [manager POST:SUGE_ADDRESSLIST parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"是否正确%@",responseObject[@"datas"][@"count"]);
        dictionary=responseObject[@"datas"];
        [addTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark tableview  delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section=indexPath.section;
//    NSInteger row=indexPath.row;
    UITableViewCell *cell=nil;
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    
    UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-200,10, 200, 40)];
    numLabel.textAlignment=NSTextAlignmentRight;
    numLabel.textColor=[UIColor lightGrayColor];
    numLabel.font=FONT(18);
    
    cell.imageView.image=IMAGE(imageArray[section]);
    cell.textLabel.text=nameArray[section];
    numLabel.text=[NSString stringWithFormat:@"%@人",dictionary[@"count"][counyArray[section]]];
    [cell.contentView addSubview:numLabel];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    LBPartnerViewController *partner=[[LBPartnerViewController alloc]init];
    LBCustomViewController *custom=[[LBCustomViewController alloc]init];
    if (indexPath.row==0) {
        [self.navigationController pushViewController:partner animated:YES];
    }else{
        [self.navigationController pushViewController:custom animated:YES];
    }
}
#pragma mark 邀请合伙人
-(void)invitePartner
{
    LBInviteViewController *Invite=[[LBInviteViewController alloc]init];
    [self.navigationController pushViewController:Invite animated:YES];
}
@end
