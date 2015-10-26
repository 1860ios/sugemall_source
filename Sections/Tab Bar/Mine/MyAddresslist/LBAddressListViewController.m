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
static NSString *cid=@"cid";
@interface LBAddressListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSDictionary *dictionary;
    NSDictionary *dictionary1;

    NSMutableArray *customArray;
    NSMutableArray *DatasArray;
    int _curpage;
}
@property(nonatomic,strong)UITableView *addTableView;
@end
@implementation LBAddressListViewController
@synthesize addTableView;
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"通讯录";
    DatasArray= [NSMutableArray array];
    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"add_bank") style:UIBarButtonItemStylePlain target:self action:@selector(addAddress)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self loadAddressDatas];
    [self initTableView];
    _curpage=1;

    
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    UITableViewCell *cell=nil;
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    if (indexPath.section==1) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    
    UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-200,0, 200, 44)];
    numLabel.textAlignment=NSTextAlignmentRight;
    numLabel.textColor=[UIColor lightGrayColor];
    numLabel.font=FONT(13);
    
    
    if (section==0&&row==0) {
        cell.imageView.image=IMAGE(@"通讯录_03");
        cell.textLabel.text=@"我的合伙人";
        numLabel.text=[NSString stringWithFormat:@"%@人",dictionary[@"count"][@"partner"]];
        [cell.contentView addSubview:numLabel];
    }else if (section==0&&row==1)
    {
        cell.imageView.image=IMAGE(@"通讯录_06");
        cell.textLabel.text=@"我的客户";

        numLabel.text=[NSString stringWithFormat:@"%@人",dictionary[@"count"][@"custom"]];
        [cell.contentView addSubview:numLabel];}
//        //用户头像
//       UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
//        userIcon.userInteractionEnabled = YES;
//        userIcon.contentMode = UIViewContentModeScaleAspectFit;
//        userIcon.layer.cornerRadius = 25;
//        userIcon.layer.masksToBounds  = YES;
//        [cell.contentView addSubview:userIcon];
//        
//        UILabel *cardLabel=[[UILabel alloc]initWithFrame:CGRectMake(userIcon.frame.origin.x+userIcon.frame.size.width+10, userIcon.frame.origin.y, 200, 20)];
//        cardLabel.textAlignment=NSTextAlignmentLeft;
//        cardLabel.textColor=[UIColor blackColor];
//        cardLabel.font=FONT(15);
//        [cell.contentView addSubview:cardLabel];
//
//        UILabel *contributeLabel=[[UILabel alloc]initWithFrame:CGRectMake(cardLabel.frame.origin.x, cardLabel.frame.origin.y+cardLabel.frame.size.height, 200, 20)];
//        contributeLabel.textAlignment=NSTextAlignmentLeft;
//        contributeLabel.textColor=[UIColor lightGrayColor];
//        contributeLabel.font=FONT(13);
//        [cell.contentView addSubview:contributeLabel];
//
//        UILabel *teamLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-200, contributeLabel.frame.origin.y, 200, 20)];
//        teamLabel.textAlignment=NSTextAlignmentRight;
//        teamLabel.textColor=[UIColor lightGrayColor];
//        teamLabel.font=FONT(13);
//        [cell.contentView addSubview:teamLabel];
//
//        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(contributeLabel.frame.origin.x, contributeLabel.frame.origin.y+contributeLabel.frame.size.height+10, SCREEN_WIDTH-userIcon.frame.size.width, 1)];
//        lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
//        [cell.contentView addSubview:lineView];
//        
//            [userIcon sd_setImageWithURL:[NSURL URLWithString:DatasArray[indexPath.row][@"member_avatar"]] placeholderImage:IMAGE(@"myrefrere_Icon")];
//            cardLabel.text=DatasArray[indexPath.row][@"member_name"];
//            contributeLabel.text=[NSString stringWithFormat:@"贡献值:%@元",DatasArray[indexPath.row][@"contribution"]];
//            teamLabel.text=[NSString stringWithFormat:@"团队值:%@人",DatasArray[indexPath.row][@"count_teams"]];
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
-(void)addAddress
{
    LBInviteViewController *Invite=[[LBInviteViewController alloc]init];
    [self.navigationController pushViewController:Invite animated:YES];
}
@end
