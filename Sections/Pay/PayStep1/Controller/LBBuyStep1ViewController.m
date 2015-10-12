//
//  LBBuyStep1ViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBBuyStep1ViewController.h"
#import "addressCell.h"
#import "goodsCell.h"
#import "LBDistributionmodeCell.h"
#import "goodsFreightCell.h"
#import "UtilsMacro.h"
#import <MobClick.h>
#import "invoiceCell.h"
#import "LBStep1GoodsListModel.h"
#import "LBBuyStep1Model.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "TSMessage.h"
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import "MJExtension.h"
#import "LBStoreCartListModel.h"
#import "LBBuyStep2ViewController.h"
#import "LBInvoiceListViewController.h"
#import "LBMyAddressViewController.h"
#import "LBNewAddressView.h"


static NSString *addressCellcid = @"addressCell";
static NSString *cid = @"cid";
static NSString *goodsCellcid = @"goodsCell";
static NSString *freight = @"cell";
static NSString *invoice = @"invoiceCell";

@interface LBBuyStep1ViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    LBBuyStep1Model *modelStep1;
    LBStoreCartListModel *storeCarList;
    LBStep1GoodsListModel*goodsList;
    NSArray *goodsListArray;
    
    NSMutableArray *arrayGoods;
    NSMutableArray *storeTotalArray;
    
    NSArray *storeCarListArray;
    int count;
    
    NSString *tr1;
    NSString *tr2;
    NSString *tr3;
    
    NSString *allNum;
    UILabel *orderMoney;
    
//    NSString *koko;
    NSString *_offpay_hash;
    NSString *_offpay_hash_batch;
    
    //接收更换地址的传值
    NSString *add_id;
    NSString *invoice_id;
    //
    NSInteger yunfeiNum ;
    float goodsTotalNum1 ;

}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) BOOL changeAddress;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSDictionary *inv_info;
@property (nonatomic,strong) NSString *invoiceStr;//发票类型，接收传值
@property (nonatomic,strong) UILabel *invoiceContent;//发票内容

@end

@implementation LBBuyStep1ViewController
@synthesize _address_id,_cart_id,_ifcart,_invoice_id,_pay_name,_totalMoney,
_vat_hash,_allow_offpay;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写订单";
    self.view.backgroundColor = [UIColor whiteColor];
    //通知传值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification:) name:@"ChangeNameNotification" object:nil];
    
    [self addTableView];
    [self initOrderBottom];
    [self loadStep1Datas];
    
    
}
-(void)ChangeNameNotification:(NSNotification*)notification{
    
    NSDictionary *nameDictionary = [notification userInfo];
    
    modelStep1.address_info.true_name = [nameDictionary objectForKey:@"true_name"];
    modelStep1.address_info.mob_phone = [nameDictionary objectForKey:@"mob_phone"];
    modelStep1.address_info.area_info = [nameDictionary objectForKey:@"area_info"];
    modelStep1.address_info.address = [nameDictionary objectForKey:@"address"];

    _offpay_hash = nil;
    _offpay_hash = [nameDictionary objectForKey:@"offpay_hash"];
    _offpay_hash_batch = nil;
    _offpay_hash_batch = [nameDictionary objectForKey:@"offpay_hash_batch"];
    add_id = nil;
    add_id =[nameDictionary objectForKey:@"address_id"];
    
    [_tableView reloadData];
}

-(void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT  - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[addressCell class]forCellReuseIdentifier:addressCellcid];
    [_tableView registerClass:[goodsCell class] forCellReuseIdentifier:goodsCellcid];
    [_tableView registerClass:[LBDistributionmodeCell class] forCellReuseIdentifier:cid];
    [_tableView registerClass:[goodsFreightCell class] forCellReuseIdentifier:freight];
    [_tableView registerClass:[invoiceCell class] forCellReuseIdentifier:invoice];
    [self.view addSubview:_tableView];

}

#pragma mark 购买第一步
- (void)loadStep1Datas
{
    //key
    NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
    //HUD 提示
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
//    koko = _cart_id;
    NSDictionary *parameter = @{@"key":key,@"cart_id":_cart_id,@"ifcart":_ifcart};
    
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_BUY_STEP1 parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        //dismiss
        [SVProgressHUD dismiss];
        NSLog(@"购买第一步:responObject:%@,错误:%@",responObject[@"datas"],responObject[@"datas"][@"error"]);
        if (responObject[@"datas"][@"error"] != nil) {
            NSString *error = responObject[@"datas"][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 112;
            [alert show];
        }else{
        modelStep1 = [LBBuyStep1Model objectWithKeyValues:responObject[@"datas"]];
        _dict = [NSDictionary dictionary];
        _dict = responObject[@"datas"][@"store_cart_list"];
       
        arrayGoods = [[NSMutableArray alloc]init];
        storeTotalArray = [[NSMutableArray alloc]init];
        NSMutableDictionary *goodsDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *storeDict= [NSMutableDictionary dictionary];

            NSInteger yunfeiNum1 = 0;

        for (int i = 0; i < _dict.count; i ++) {
            storeDict = [[NSMutableDictionary alloc]initWithDictionary:_dict[_dict.allKeys[i]]];
            [storeDict removeObjectForKey:@"goods_list"];
            [storeTotalArray addObject:storeDict];
        
            NSArray *goodArray = [NSArray array];
            goodsDic = _dict[_dict.allKeys[i]];
            goodArray = _dict[_dict.allKeys[i]][@"goods_list"];
            count += goodArray.count;
            for (int j = 0; j < goodArray.count; j ++) {
                [arrayGoods addObject:goodArray[j]];
            }
            

            NSString *_yunfei1 = [responObject[@"datas"][@"store_cart_list"] allKeys][i];
            NSDictionary *_yunfei2 = [responObject[@"datas"][@"store_cart_list"] objectForKey:_yunfei1];
            NSArray *goodsList1 = [_yunfei2 objectForKey:@"goods_list"];
            for (int i = 0;i<goodsList1.count; i++) {
                NSString *yunfei3 = [goodsList1[i] valueForKey:@"goods_freight"];
                //是否运费
                NSString *isfreight = [_yunfei2 objectForKey:@"freight"];
                if ([isfreight isEqualToString:@"1"]) {
                    //运费
                    yunfeiNum1 = [yunfei3 integerValue];
                    yunfeiNum +=yunfeiNum1;
                    
                }else{
                    yunfeiNum = 0;
                }
            }
            NSString *goodsTotal = [_yunfei2 objectForKey:@"store_goods_total"];
            //总价
            float goodsTotalNum = [goodsTotal floatValue];
            goodsTotalNum1 += goodsTotalNum;
            NSLog(@"goodsTotalNum:%0.2f,yunfeiNum:%ld",goodsTotalNum1,(long)yunfeiNum);
        }

        allNum = [NSString stringWithFormat:@"%0.2f",yunfeiNum+goodsTotalNum1];
            orderMoney.text = allNum;//商品的总价格
        storeCarListArray = [LBStoreCartListModel objectArrayWithKeyValuesArray:storeTotalArray];
        goodsListArray = [LBStep1GoodsListModel objectArrayWithKeyValuesArray:arrayGoods];
        goodsList = [LBStep1GoodsListModel objectWithKeyValues:goodsDic[@"goods_list"]];
        storeCarList = [LBStoreCartListModel objectWithKeyValues:storeDict];
            
        tr1 = modelStep1.freight_hash;
        tr2 = modelStep1.address_info.city_id;
        tr3 = modelStep1.address_info.area_id;
//        invoice_id = modelStep1.inv_info[@"inv_id"];
          invoice_id = @"";
            if (tr2 == nil) {
            [TSMessage showNotificationWithTitle:@"提示" subtitle:@"对不起,您还没有收货地址呢~请先创建收货地址" type:TSMessageNotificationTypeWarning];
//            LBNewAddressView *newA = [[LBNewAddressView alloc] init];
//            [self.navigationController pushViewController:newA animated:YES];
            
        }else{
            [self loadAddressDatas];
         }
        }
    
       [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        NSLog(@"Error:%@", error);
    }];

}

- (void)loadAddressDatas
{
    NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
    
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];

    NSLog(@"%@%@%@",tr1,tr2,tr3);
    
    NSDictionary *parameter = @{@"key":key,@"freight_hash":tr1,@"city_id":tr2,@"area_id":tr3};
    
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_CHANGE_ADDRESS parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        
        NSLog(@"更换地址:%@",responObject[@"datas"][@"error"]);
        _offpay_hash =  responObject[@"datas"][@"offpay_hash"];
        _offpay_hash_batch = responObject[@"datas"][@"offpay_hash_batch"];
        _allow_offpay = responObject[@"datas"][@"allow_offpay"];
        NSLog(@"_offpay_hash:%@\n,_offpay_hash_batch:%@\n,_allow_offpay:%@\n",_offpay_hash,_offpay_hash_batch,_allow_offpay);

    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        NSLog(@"Error:%@", error);
    }];
    [SVProgressHUD dismiss];

}

-(void)initOrderBottom
{
    UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH - SCREEN_WIDTH/3 - 30, 49)];
    orderView.backgroundColor = [UIColor blackColor];
    orderView.alpha = 0.7;
    [self.view addSubview:orderView];
    
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 20)];
    orderLabel.text  = @"实付款:\n(含运费)";
    orderLabel.font = FONT(14);
    orderLabel.textColor = [UIColor whiteColor];
    [orderView addSubview:orderLabel];
    UILabel *yunfLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 60, 20)];
    yunfLabel.text  = @"(含运费)";
    yunfLabel.font = FONT(13);
    yunfLabel.textColor = [UIColor whiteColor];
    [orderView addSubview:yunfLabel];
    orderMoney = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 100, 30)];
   
    orderMoney.textColor = APP_COLOR;
    orderMoney.font = BFONT(21);
    [orderView addSubview:orderMoney];
    
    //提交订单
    UIButton *commitButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3 - 30, SCREEN_HEIGHT - 49, SCREEN_WIDTH/3 + 30, 49)];
    [commitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setBackgroundColor:APP_COLOR];
    [commitButton addTarget:self action:@selector(payOrderStep2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 112) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 提交订单

- (void)payOrderStep2
{
    _vat_hash = modelStep1.vat_hash;
    _invoice_id = modelStep1.inv_info[@"inv_id"];
    _pay_name = @"online";
    _address_id = modelStep1.address_info.address_id;
    if (_address_id == nil) {
        [TSMessage showNotificationWithTitle:@"提示" subtitle:@"对不起,请先创建收货地址或者发票信息~" type:TSMessageNotificationTypeWarning];
    }else{
    
    //key
    NSString *_key  =[LBUserInfo sharedUserSingleton].userinfo_key;
    //HUD 提示
    [SVProgressHUD showWithStatus:@"正在提交订单..." maskType:SVProgressHUDMaskTypeClear];
    //
//    NSString *goods_id = [NSString stringWithFormat:@"%@|%@",goodsList.goods_id,goodsList.goods_num];
    
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
        if (add_id == nil) {
            add_id = _address_id;
        }
    NSDictionary *parameter = @{@"key":_key,@"ifcart":_ifcart,@"cart_id":_cart_id,@"address_id":add_id,@"vat_hash":_vat_hash,@"offpay_hash":_offpay_hash,@"offpay_hash_batch":_offpay_hash_batch,@"pay_name":_pay_name,@"invoice_id":invoice_id};


    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_BUY_STEP2 parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSString *err =responObject[@"datas"][@"error"];
        NSLog(@"提交订单:responObject:%@",err);
        NSLog(@"提交订单:responObject:%@",responObject);
        
        NSDictionary *firstObject = responObject[@"datas"];
        NSArray *A1 =[firstObject allKeys];
        if ([[A1 firstObject] isEqualToString:@"pay_sn"]) {
        LBBuyStep2ViewController *step2 = [[LBBuyStep2ViewController alloc] init];
//#warning 商品测试数据_价格
        step2.orderId = responObject[@"datas"][@"pay_sn"];
        step2.body = goodsList.goods_name;
        step2.subject = goodsList.goods_name;
        step2.price = allNum;
//        step2.price = _totalMoney;
        [self.navigationController pushViewController:step2 animated:YES];
        
        }else{
            NSString *error = responObject[@"datas"][@"error"];
            [[[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        NSLog(@"Error:%@", error);
    }];
        //dismiss
        [SVProgressHUD dismiss];
}
}

#pragma mark datasource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.section == 2||indexPath.section == 3) {
        if (indexPath.row == 1) {
            return 44;
        }
        return 60;
    }

    return 80;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return count;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:{
            addressCell *addcell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
            [addcell addValue:modelStep1];
            addcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return addcell;
        }
            break;
        case 1:{
            goodsCell *goodCell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell"];
            goodsList = goodsListArray[row];
            [goodCell addValue:goodsList];
            return goodCell;
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                LBDistributionmodeCell *distributionmodeCell = [tableView dequeueReusableCellWithIdentifier:cid];
//                distributionmodeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return distributionmodeCell;

            }else{
                invoiceCell *invoiceCell = [tableView dequeueReusableCellWithIdentifier:invoice];
//                [invoiceCell addValue:modelStep1];
                if (_invoiceStr == nil) {
                    _invoiceStr = @"不需要发票";
                }
                invoiceCell.invoiceContent.text = _invoiceStr;
                invoiceCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return invoiceCell;
            }
        }
            break;
        case 3:{
            goodsFreightCell *freightCell = [tableView dequeueReusableCellWithIdentifier:freight];

            freightCell.goodsMoney.text =[NSString stringWithFormat:@"%0.2f",goodsTotalNum1];
            freightCell.freightMoney.text =[NSString stringWithFormat:@"+%ld",(long)yunfeiNum];
            return freightCell;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        _changeAddress = YES;
        LBMyAddressViewController *myAddressVC = [[LBMyAddressViewController alloc]init];
        myAddressVC.changeAddress = _changeAddress;
        myAddressVC.freight_hash = tr1;
        myAddressVC.isDelAddress = YES;
        [self.navigationController pushViewController:myAddressVC animated:YES];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            
        }else{
            LBInvoiceListViewController *invoiceListVC = [[LBInvoiceListViewController alloc]init];
            invoiceListVC.backValue = ^(NSDictionary *invoiceInfo){
                NSString *title = [invoiceInfo objectForKey:@"int_title"];
                NSString *content = [invoiceInfo objectForKey:@"inv_content"];
                invoice_id = [invoiceInfo objectForKey:@"inv_id"];
                _invoiceStr =[NSString stringWithFormat:@"%@ %@",title,content];
                [tableView reloadData];
                NSLog(@"invoiceStr:%@",_invoiceStr);
            };
            invoiceListVC.isChangeInvoice = YES;
            [self.navigationController pushViewController:invoiceListVC animated:YES];
        }
    }

}


#pragma mark --页面统计
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [MobClick beginLogPageView:@"填写订单"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [MobClick endLogPageView:@"填写订单"];
}



@end
