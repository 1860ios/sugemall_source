
//
//  LBMyAddressViewController.m
//  SuGeMarket
//  收货地址
//  Created by Josin on 15-4-24.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMyAddressViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "AppMacro.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "LBUserInfo.h"
#import "TSMessage.h"
#import "MJExtension.h"
#import "LBAddressListModel.h"
#import "LBAddressModel.h"
#import "LBNewAddressView.h"
#import "NotificationMacro.h"
#import "MobClick.h"
#import "MJRefresh.h"

static NSString *cid = @"cid";

@interface LBMyAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LBAddressListModel *addressListModel;
    LBAddressModel *model;
    UIButton *setDefaultButton;
    UIButton *deletButton;
    UIButton * add_button;
    NSInteger a;
    NSInteger tag;

}
@property (nonatomic, strong) UITableView *_tableView;

@end

@implementation LBMyAddressViewController
@synthesize isDelAddress;

#pragma mark viewDidLoad
- (void)viewDidLoad
{

    [super viewDidLoad];

    self.title = @"收货地址";
    //1.加载tableview
    [self drawAddressTableView];
    [self setupRefresh];
    

}//SUGE_SETDEFAULT_ADDRESS

#pragma mark drawTableView
- (void)drawAddressTableView
{
    __tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    __tableView.delegate =self;
    __tableView.dataSource =self;
    [__tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:__tableView];
    

}

#pragma mark drawBottomView
- (void)drawBottomView
{
    //bottomView
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, model.address_list.count*120, SCREEN_WIDTH-40, 40)];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    [self.view  addSubview:bottomView];
    //add_button
    if (add_button) {
        [add_button removeFromSuperview];
    }
    add_button = [UIButton buttonWithType:UIButtonTypeCustom];
    add_button.frame = CGRectMake(0,__tableView.frame.origin.y+model.address_list.count*140+20, SCREEN_WIDTH, 40);
//    add_button.layer.cornerRadius = 15;
    [add_button setTitle:@"添加新地址" forState:0];
    add_button.titleLabel.font = [UIFont systemFontOfSize:18];
    [add_button setBackgroundColor:[UIColor redColor]];
    [add_button setTitleColor:[UIColor whiteColor] forState:0];
    [add_button addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    __tableView.tableFooterView=add_button;
}
#pragma mark 添加地址
- (void)addAddress
{
    LBNewAddressView *newAddress = [[LBNewAddressView alloc] init];
    newAddress.setTag=[NSString stringWithFormat:@"%ld",(long)tag];
    newAddress.block = ^(NSString*isanble){
        _isDefault=isanble;
    };
    [self.navigationController pushViewController:newAddress animated:YES];
}
#pragma mark 设置下拉刷新
- (void)setupRefresh
{
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self._tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadDatas];
    }];
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


#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%ld",(long)tag);
    
    if (tag&&[_isDefault isEqual:@"1"]) {
    [self LoadAddressURL:SUGE_SET_MOREN address_id:[NSString stringWithFormat:@"%ld",(long)tag] type:@"default"];
    }
    [self loadDatas];
    [self setupRefresh];

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的收货地址"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的收货地址"];
}
- (void)loadDatas
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"key":key};
    [manager POST:SUGE_ADDRESS_LIST parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"address_list_responObject:%@",responObject);
        //miss提示
        [SVProgressHUD dismiss];
        //转模型
        model = [LBAddressModel objectWithKeyValues:responObject[@"datas"]];
        //
        NSMutableArray *arr =responObject[@"datas"][@"address_list"];
        //判断收货数组是否为空
        if (arr.count == 0) {
            NSLog(@"收货数组为空");
            self._tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGE(@"suge_no_address")];
        }else{
            self._tableView.backgroundView = [UIView new];
        }
        
        //刷新tableview
        [self._tableView reloadData];
        [self drawBottomView];

        //结束刷新
        [self._tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"error:%@",error);
    }];

}

#pragma mark TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return model.address_list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;//section头部高度
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;//section头部高度
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.accessoryType = UITableViewCellAccessoryNone;
        //平滑
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;

    }
    
    //cell.userInteractionEnabled = NO;
    //
    NSInteger section = indexPath.section;
    addressListModel = model.address_list[section];
    
    //收货人
    UILabel *trueName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    trueName.adjustsFontSizeToFitWidth = YES;
    trueName.text = addressListModel.true_name;
    trueName.font = [UIFont boldSystemFontOfSize:16];
    [cell.contentView addSubview:trueName];

    //手机号
    UILabel *mobPhone = [[UILabel alloc] initWithFrame:CGRectMake(trueName.frame.origin.x+trueName.frame.size.width, trueName.frame.origin.y, 100, 30)];
    mobPhone.adjustsFontSizeToFitWidth = YES;
    mobPhone.font = [UIFont boldSystemFontOfSize:16];
    mobPhone.text = addressListModel.mob_phone;
    mobPhone.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:mobPhone];
    
    //收货地址
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(trueName.frame.origin.x, trueName.frame.origin.y+trueName.frame.size.height+5, SCREEN_WIDTH-50, 30)];
    address.numberOfLines = 2;
    
    address.font = [UIFont systemFontOfSize:16];//area_info
    NSString *add = [addressListModel.area_info stringByAppendingString:addressListModel.address];
    address.text = add;
    [cell.contentView addSubview:address];
    
    setDefaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setDefaultButton.frame=  CGRectMake(20,address.frame.origin.y+address.frame.size.height+10, 25, 25);
    [setDefaultButton setTag:[addressListModel.address_id integerValue]];
    [setDefaultButton setImage:IMAGE(@"syncart_round_check1@2x") forState:0];
    [setDefaultButton setImage:IMAGE(@"syncart_round_check2@2x") forState:UIControlStateSelected];
    [setDefaultButton addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:setDefaultButton];
    //判断是否默认地址

    if ([addressListModel.is_default isEqualToString:@"1"]) {
        address.text = [NSString stringWithFormat:@"[默认]%@",add];
        setDefaultButton.selected  =YES;
    }
    if (section==0) {
        tag=[addressListModel.address_id integerValue]+1;
    }
    
    UILabel *setDefaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(setDefaultButton.frame.origin.x+setDefaultButton.frame.size.width, setDefaultButton.frame.origin.y, 80, 25)];
    setDefaultLabel.font = FONT(13);
    setDefaultLabel.text = @"设为默认";
    [cell addSubview:setDefaultLabel];
    
    deletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deletButton.frame=CGRectMake(SCREEN_WIDTH-60, setDefaultLabel.frame.origin.y, 40, 25);
    [deletButton setTitle:@"删除" forState:0];
    deletButton.titleLabel.font=FONT(12);
    [deletButton setTitleColor:[UIColor blackColor] forState:0];
    [deletButton setTag:[addressListModel.address_id integerValue]];
    [deletButton addTarget:self action:@selector(deleAddress:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:deletButton];
    if (isDelAddress) {
        deletButton.hidden = YES;
    }else{
        deletButton.hidden = NO;
    }
    
    UIImageView *deletImageView=[[UIImageView alloc]initWithFrame:CGRectMake(deletButton.frame.origin.x-20, deletButton.frame.origin.y, 20, 20)];
    deletImageView.image=IMAGE(@"4321");
    [cell.contentView addSubview:deletImageView];
    
   UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame=CGRectMake(deletImageView.frame.origin.x-20-40, deletImageView.frame.origin.y, 40, 25);
    [editButton setTitle:@"编辑" forState:0];
    editButton.titleLabel.font=FONT(12);
    [editButton setTag:indexPath.section];
    [editButton addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitleColor:[UIColor blackColor] forState:0];
    [cell addSubview:editButton];
    if (isDelAddress) {
        editButton.hidden = YES;
    }else{
        editButton.hidden = NO;
    }
        a=indexPath.section;

    NSLog(@"%ld",(long)indexPath.section);
    UIImageView *editImageView=[[UIImageView alloc]initWithFrame:CGRectMake(editButton.frame.origin.x-15, setDefaultLabel.frame.origin.y, 20, 20)];
    editImageView.image=IMAGE(@"123");
    [cell.contentView addSubview:editImageView];
    return cell;
}
-(void)editAddress:(UIButton *)btn
{
    NSInteger row = btn.tag;
    NSLog(@"%ld",row);
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:row];
    [self._tableView.delegate tableView:__tableView didSelectRowAtIndexPath:path];
}
//删除地址
- (void)deleAddress:(UIButton *)btn
{
    NSInteger row = btn.tag;
    NSString *row1 = [NSString stringWithFormat:@"%ld",(long)row];
    NSLog(@"address_row:%@",row1);

     [self LoadAddressURL:SUGE_ADDRESS_DEL address_id:row1 type:@"del"];
}

//设为默认
- (void)setDefaultAddress:(UIButton *)btn
{
    NSInteger row = btn.tag;
    NSString *row1 = [NSString stringWithFormat:@"%ld",(long)row];
    NSLog(@"address_row:%@",row1);
    
    
    [self LoadAddressURL:SUGE_SET_MOREN address_id:row1 type:@"default"];
}

- (void)LoadAddressURL:(NSString *)url address_id:(NSString *)add_id type:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    //登陆key
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"key":key,@"address_id":add_id};
    
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"responObject:%@",responObject);
        
        if ([responObject[@"datas"] isEqualToString:@"1"]) {
            
            //再次请求数据
            [self loadDatas];
        }
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
    }];
     [SVProgressHUD dismiss];

}

#pragma mark TableView SEL
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self._tableView deselectRowAtIndexPath:indexPath animated:YES];
   NSInteger section = indexPath.section;
    addressListModel = model.address_list[section];
    NSString *k1 = addressListModel.city_id;
    NSString *k2 = addressListModel.area_id;
    NSString *k3 = addressListModel.address_id;
//#warning 收货地址更换传值
    //传值

    if (_changeAddress) {
        
        NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
        
        AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter = @{@"key":key,@"freight_hash":_freight_hash,@"city_id":k1,@"area_id":k2};

        maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        
        [maneger POST:SUGE_CHANGE_ADDRESS parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            [SVProgressHUD dismiss];
            NSLog(@"更换地址:%@",responObject[@"datas"]);
            
            NSString *_offpay_hash =  responObject[@"datas"][@"offpay_hash"];
            NSString *_offpay_hash_batch = responObject[@"datas"][@"offpay_hash_batch"];
            NSString *_allow_offpay = responObject[@"datas"][@"allow_offpay"];
            NSLog(@"所更换的地址:_offpay_hash:%@\n,_offpay_hash_batch:%@\n,_allow_offpay:%@\n",_offpay_hash,_offpay_hash_batch,_allow_offpay);
            
            NSDictionary *myUserInfo = @{@"true_name":addressListModel.true_name,@"mob_phone":addressListModel.mob_phone,@"area_info":addressListModel.area_info,@"address":addressListModel.address,@"offpay_hash":_offpay_hash,@"offpay_hash_batch":_offpay_hash_batch,@"allow_offpay":_allow_offpay,@"address_id":k3};
            //通知地址传值
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification"object:self userInfo:myUserInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
            NSLog(@"Error:%@", error);
        }];
        
    }else{
        LBNewAddressView *newAddress = [[LBNewAddressView alloc] init];
        newAddress._trueName = addressListModel.true_name;
        newAddress._telPhone = addressListModel.tel_phone;
        newAddress._areaInfo = addressListModel.area_info;
        newAddress._address = addressListModel.address;
        newAddress._navTitle = @"修改地址";
        newAddress.isEdict = YES;
        newAddress.address_id = k3;
    [self.navigationController pushViewController:newAddress animated:YES];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //提示
        [SVProgressHUD showWithStatus:@"删除中..." maskType:SVProgressHUDMaskTypeClear];
        
        addressListModel = model.address_list[indexPath.section];
        //登陆key
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        //地址编号
        NSString * address_id = addressListModel.address_id;
        NSLog(@"address_id:%@",address_id);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        NSDictionary *parameter =@{@"key":key,@"address_id":address_id};
        
        [manager POST:SUGE_ADDRESS_DEL parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            
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
