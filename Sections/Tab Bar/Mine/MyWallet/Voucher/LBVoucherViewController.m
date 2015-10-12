//
//  LBVoucherViewController.m
//  SuGeMarket
//
//  Created by Apple on 15/7/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBVoucherViewController.h"
#import "UtilsMacro.h"
#import "LBvoucherTableViewCell.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import "SUGE_API.h"
#import <TSMessage.h>
#import "LBUserInfo.h"
#import <UIImageView+WebCache.h>

static NSString *cid = @"cid";

@interface LBVoucherViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *VoucherTableView;
    NSMutableArray *voucherArray;
}
@end

@implementation LBVoucherViewController
@synthesize voucher_state;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.97];

    [self initTableView];
    [self loadViewControll_type:voucher_state];
    
}
-(void)loadViewControll_type:(NSString *)_state
{
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
   NSDictionary *parameters =@{@"key":key,@"voucher_state":_state};
    [maneger POST:SUGE_VOUCHER_LIST parameters:parameters success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"我的代金券:%@",responObject);
        voucherArray = responObject[@"datas"][@"voucher_list"];
        if (voucherArray.count == 0) {
            VoucherTableView.backgroundView = [[UIImageView alloc] initWithImage:IMAGE(@"no_record")];
        }else{
            VoucherTableView.backgroundView = [UIView new];
            [VoucherTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"网络错误:%@",error);
    }];
}
-(void)initTableView
{
    VoucherTableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    VoucherTableView.delegate = self;
    VoucherTableView.dataSource = self;
    [VoucherTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:VoucherTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    LBvoucherTableViewCell *cell = nil;
    if (!cell) {
        cell = [[LBvoucherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
            NSString *url=voucherArray[section][@"voucher_t_customimg"];
    [cell.voucherImageView sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:IMAGE(@"dd_03_@2x")];
    cell.nameLabel.text=voucherArray[section][@"voucher_title"];
    cell.usageModelLabel.text=voucherArray[section][@"voucher_desc"];
//    NSString *state =voucherArray[section][@"voucher_state"];

    cell.numLabel.text=voucherArray[section][@"voucher_id"];
    cell.houseImageView.image=IMAGE(@"store_image.png");

    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return voucherArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

@end
