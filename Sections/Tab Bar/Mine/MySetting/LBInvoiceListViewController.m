//
//  LBInvoiceListViewController.m
//  SuGeMarket
//
//  Created by Josin on 15-4-24.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBInvoiceListViewController.h"
#import "UtilsMacro.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "TSMessage.h"
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import "LBInvoiceAddViewController.h"
#import "MobClick.h"
#import "MJRefresh.h"

static NSString *cid = @"cid";

@interface LBInvoiceListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, strong) NSMutableArray *invoiceListArray;
@end

@implementation LBInvoiceListViewController
@synthesize isChangeInvoice;

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.title = @"我的发票";
    //1.加载tableview
    [self drawAddressTableView];
    //
    [self drawBottomView];
    [self setupRefresh];
    [self loadDatas];

}

#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的发票"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的发票"];
}

#pragma mark drawTableView
- (void)drawAddressTableView
{
    __tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    
    __tableView.delegate =self;
    __tableView.dataSource =self;
    
    [__tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:__tableView];
    
}

#pragma mark 设置下拉刷新
- (void)setupRefresh
{
    
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self._tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadDatas)];
    // 隐藏时间
    self._tableView.header.updatedTimeHidden = YES;
    // 设置文字
    [self._tableView.header setTitle:APP_REFRESH_TEXT_STATID forState:MJRefreshHeaderStateIdle];
    [self._tableView.header setTitle:APP_REFRESH_TEXT_PULLING forState:MJRefreshHeaderStatePulling];
    [self._tableView.header setTitle:APP_REFRESH_TEXT_REFRESHING forState:MJRefreshHeaderStateRefreshing];
    
    // 设置字体
    self._tableView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    self._tableView.header.textColor = APP_COLOR;
}


#pragma mark loadDatas
- (void)loadDatas
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];

    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"key":key};
    [manager POST:SUGE_INVOICE_LIST parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"SUGE_INVOICE_LIST_responObject:%@",responObject);
        //结束刷新
        [self._tableView.header endRefreshing];
        
        _invoiceListArray = responObject[@"datas"][@"invoice_list"];
        //判断发票数组是否为空
        if (_invoiceListArray.count == 0) {
            NSLog(@"发票数组为空");
            self._tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGE(@"suge_no_invoice")];
        }else{
            self._tableView.backgroundView = [UIView new];
        }
        //刷新tableview
        [self._tableView reloadData];

        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"error:%@",error);
    }];
    //miss提示
    [SVProgressHUD dismiss];
    
}

#pragma mark drawBottomView
- (void)drawBottomView
{
    //bottomView
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view  addSubview:bottomView];
    
    UIButton * add_button = [UIButton buttonWithType:UIButtonTypeCustom];
    add_button.frame = CGRectMake(bottomView.center.x-80, bottomView.center.y-18, 160, 30);
    add_button.layer.cornerRadius = 15;
    [add_button setTitle:@"添加新发票" forState:0];
    add_button.titleLabel.font = [UIFont systemFontOfSize:18];
    [add_button setBackgroundColor:[UIColor redColor]];
    [add_button setTitleColor:[UIColor whiteColor] forState:0];
    [add_button addTarget:self action:@selector(addInvoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add_button];
}

#pragma mark  保存
- (void)addInvoice
{
    LBInvoiceAddViewController *addInvoice = [[LBInvoiceAddViewController alloc] init];
    [self.navigationController pushViewController:addInvoice animated:YES];

}

#pragma mark TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _invoiceListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    NSInteger row = indexPath.section;
    //发票内容
    UILabel *invID = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 30)];
    invID.adjustsFontSizeToFitWidth = YES;
    invID.text = [NSString stringWithFormat:@"发票编号:%@",_invoiceListArray[row][@"inv_id"]];
    invID.font = [UIFont boldSystemFontOfSize:16];
    [cell.contentView addSubview:invID];
    
    //发票id
    UILabel *invTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, invID.frame.origin.y, 100, 30)];
    invTitle.adjustsFontSizeToFitWidth = YES;
    invTitle.font = [UIFont boldSystemFontOfSize:16];
    invTitle.text = _invoiceListArray[row][@"inv_title"];
    [cell.contentView addSubview:invTitle];
    
    //发票标题
    UILabel *invContent = [[UILabel alloc] initWithFrame:CGRectMake(invID.frame.origin.x, invID.frame.origin.y+invID.frame.size.height+5, SCREEN_WIDTH-50, 30)];
    invContent.adjustsFontSizeToFitWidth = YES;
    invContent.font = [UIFont systemFontOfSize:16];
    invContent.text = _invoiceListArray[row][@"inv_content"];
    [cell.contentView addSubview:invContent];
        
    
    return cell;
}


#pragma mark TableView SEL
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self._tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (isChangeInvoice) {
        NSDictionary *invDic = @{@"inv_id":_invoiceListArray[row][@"inv_id"],@"int_title":_invoiceListArray[row][@"inv_title"],@"inv_content":_invoiceListArray[row][@"inv_content"]};
        //代码块传值
        self.backValue(invDic);
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        
    }
    
}

#pragma mark TableView  DEL
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //提示
        [SVProgressHUD showWithStatus:@"删除中..." maskType:SVProgressHUDMaskTypeClear];
        
        NSInteger row = indexPath.section;

        //登陆key
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        //地址编号
        NSString *invID = _invoiceListArray[row][@"inv_id"];
//        NSLog(@"address_id:%@",address_id);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        NSDictionary *parameter =@{@"key":key,@"inv_id":invID};
        
        [manager POST:SUGE_INVOICE_DEL parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            
            [SVProgressHUD dismiss];
            NSLog(@"responObject:%@",responObject);
            
            if ([responObject[@"datas"] isEqualToString:@"1"]) {
                
                //再次请求数据
                [self loadDatas];
            }
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
        }];

    }
    
}




@end


