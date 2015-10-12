//
//  LBrecordViewController.m
//  SuGeMarket
//  提现记录
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBrecordViewController.h"
#import "UtilsMacro.h"
#import "LBRecordViewCell.h"
#import "LBUserInfo.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "SUGE_API.h"


static NSString *cid = @"cid";

@interface LBrecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *RecordTableView;
    NSMutableArray *recordDatas;
}
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation LBrecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提现记录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadMyrecordSegmentedControll];
    [self initMyrecordView];
    [self loadMyrecordDatas_type:@""];

}

- (void)loadMyrecordSegmentedControll
{
    NSString *s1 = @"全部";
    NSString *s2 = @"未到账";
    NSString *s3 = @"已到账";
    NSArray *segmentedArray = @[s1,s2,s3];
    //初始化UISegmentedControl
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(10,68,SCREEN_WIDTH-20,35);
    _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _segmentedControl.tintColor = APP_COLOR;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    [_segmentedControl addTarget:self action:@selector(MyrecordSegmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    
    [self.view addSubview:_segmentedControl];
}

- (void)MyrecordSegmentAction:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSString *type;
    NSLog(@"Index %li", (long)Index);
    switch (Index) {
        case 0:
            type = @"";
            break;
            
        case 1:
            type = @"0";
            break;
            
        case 2:
            type = @"1";
            break;
    }
    [self loadMyrecordDatas_type:type];

}

-(void)loadMyrecordDatas_type:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *dict = @{@"key":key,@"paystate_search":type,@"sn_search":@""};
    
    [manager POST:SUGE_PD_CASH_LIST parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"提现记录:%@",responseObject);
        recordDatas = responseObject[@"datas"][@"list"];
        
        [RecordTableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"%@",error);
    }];
    [SVProgressHUD dismiss];
}



-(void)initMyrecordView
{
    RecordTableView= [[UITableView alloc] initWithFrame:CGRectMake(0,113, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        RecordTableView.delegate = self;
        RecordTableView.dataSource = self;
        RecordTableView.showsHorizontalScrollIndicator = YES;
//        RecordTableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [RecordTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
        RecordTableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.97];
        
        // WithdrawalTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:RecordTableView];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    LBRecordViewCell *cell = nil;
    if (!cell) {
        cell = [[LBRecordViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    cell.dataTextField.text=recordDatas[row][@"pdc_add_time"];
    cell.carnumTextField.text=recordDatas[row][@"pdc_bank_no"];
    cell.drawalTextField.text=recordDatas[row][@"pdc_bank_name"];
    NSString *state = recordDatas[row][@"pdc_payment_state"];
    if ([state isEqualToString:@"0"]) {
        cell.applyTextField.text=[NSString stringWithFormat:@"%@ 提交申请,正在等待审核. ",recordDatas[row][@"pdc_payment_time"]];
        cell.waitTextField.text=@"等待审核";
    }else{
        cell.applyTextField.text = @"已到账";
        cell.waitTextField.text=@"已到账";
    }
    
    cell.moneyTextField.text=[NSString stringWithFormat:@"￥:%@",recordDatas[row][@"pdc_amount"]];
    
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 150;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recordDatas.count;
}



@end
