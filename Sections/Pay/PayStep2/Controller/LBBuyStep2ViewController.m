//
//  LBBuyStep2ViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBBuyStep2ViewController.h"
#import "UtilsMacro.h"
#import "VendorMacro.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "VendorMacro.h"
#import "LBPayDoneView.h"
//#import "UPPayPluginDelegate.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//#import "UPPayPlugin.h"
#import "payRequsestHandler.h"
#import "WXApi.h"
#import <MBProgressHUD.h>
#import "LBOrderListViewController.h"
#import "AppMacro.h"
#import "NotificationMacro.h"
#import "HostViewController.h"
#import "LBUserInfo.h"
#import <AFNetworking.h>
#import "SUGE_API.h"
static NSString *cid =  @"cid";
@interface LBBuyStep2ViewController ()
//@interface LBBuyStep2ViewController ()<UPPayPluginDelegate,WXApiDelegate,UIAlertViewDelegate,UIAlertViewDelegate>
{
    NSArray *payTexts;
    NSArray *payImages;
    UIAlertView *alter;
    UIAlertView* _alertView;
    NSMutableData* _responseData;
    NSDictionary *rechargeDictionary;;
}

//- (void)startNetWithURL:(NSURL *)url;
@end

@implementation LBBuyStep2ViewController
@synthesize _tableView;
@synthesize tnMode;
@synthesize pdr_amount;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付方式";
    [NOTIFICATION_CENTER addObserver:self selector:@selector(wxPayReslut:) name:SUGE_WX_PAY_RESULT object:nil];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"首页"
                                                                    style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    self.navigationItem.rightBarButtonItem = rightButton;
    payTexts = @[@"支付宝支付",@"微信支付"];
    //        payTexts = @[@"支付宝支付",@"银联支付",@"微信支付",@"财付通支付"];
    //    payImages = @[@"alipay_icon",@"unionpay_icon",@"ic_wxpay",@"tenpay_icon"];
    payImages = @[@"alipay_icon",@"ic_wxpay"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
    NSLog(@"%@",pdr_amount);
    if (pdr_amount!=NULL) {
        [self loadData:pdr_amount];
    }
    
}
#pragma ==============获取充值数据==============
-(void)loadData:(NSString *)pdr
{
    rechargeDictionary=[NSDictionary dictionary];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter=@{@"key":key,@"pdr_amount":pdr};
    [manager POST:SUGE_RECHARGE parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"充值%@",responseObject);
        rechargeDictionary=responseObject[@"datas"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)backToHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//#pragma mark -
//#pragma mark   ==============产生随机订单号==============
//
//
//- (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand( time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSInteger row =indexPath.row;
    cell.textLabel.text = payTexts[row];
    cell.imageView.image =[UIImage imageNamed:payImages[row]];

    return cell;
}

#pragma  mark   ------------------支付方式----------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    switch (row) {
#pragma  mark   -------------------支付宝支付---------------------
        case 0:{
            /*============================================================================*/
            /*=======================需要填写商户app申请的===================================*/
            /*============================================================================*/
            NSString *partner = kPartner;
            NSString *seller = kSeller;
            NSString *privateKey = kPrivateKey;
            /*============================================================================*/
            /*============================================================================*/
            /*============================================================================*/
            
            //partner和seller获取失败,提示
            if ([partner length] == 0 ||
                [seller length] == 0 ||
                [privateKey length] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"缺少partner或者seller或者私钥。"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            /*
             *生成订单信息及签名
             */
            //将商品信息赋予AlixPayOrder的成员变量
            Order *order = [[Order alloc] init];
            NSLog(@"_orderId:%@",_orderId);
            order.partner = partner;
            order.seller = seller;
            order.tradeNO = _orderId; //订单ID（由商家自行制定）
            order.productName = _subject; //商品标题
            order.productDescription = _body; //商品描述
            order.amount = [NSString stringWithFormat:@"%@",_price]; //商品价格
            NSLog(@"%@",_body);
            if (pdr_amount!=NULL) {
                order.tradeNO =rechargeDictionary[@"pay_sn"] ; //订单ID（由商家自行制定）
                order.amount=rechargeDictionary[@"pdr_amount"];
            }
            order.notifyURL =  @"http://sugemall.com/mobile/api/payment/zhifubao/notify_url.php"; //回调URL
            
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            order.showUrl = @"m.alipay.com";
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = kScheme;
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            NSLog(@"orderSpec = %@",orderSpec);
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(privateKey);
            NSString *signedString = [signer signString:orderSpec];
            
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];

                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                    NSLog(@"reslut = %@",resultDic);
//                    NSString *str1;
//                    if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]) {
//                        LBOrderListViewController *payDoneVC = [[LBOrderListViewController alloc] init];
//                        payDoneVC._orderStatus = @"0";
//                        [self.navigationController pushViewController:payDoneVC animated:YES];
//                    }else if([resultDic[@"resultStatus"]isEqualToString:@"8000"]){
//                         str1 = @"正在处理中~";
//                        [[[UIAlertView alloc] initWithTitle:@"提示" message:str1 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//
//                    }
//                    else if([resultDic[@"resultStatus"]isEqualToString:@"4000"]){
//                        str1 = @"订单支付失败~";
//                        LBOrderListViewController *payDoneVC = [[LBOrderListViewController alloc] init];
//                        payDoneVC._orderStatus = @"10";                        
//                        [self.navigationController pushViewController:payDoneVC animated:YES];
//                        
//                    }
//                    else if([resultDic[@"resultStatus"]isEqualToString:@"6001"]){
////                        str1 = @"订单取消支付~";
//                        LBOrderListViewController *payDoneVC = [[LBOrderListViewController alloc] init];
//                        payDoneVC._orderStatus = @"10";
//                        [self.navigationController pushViewController:payDoneVC animated:YES];
//                        
//                    }
//                    else if([resultDic[@"resultStatus"]isEqualToString:@"6002"]){
//                        str1 = @"网络连接出错~";
//                        [[[UIAlertView alloc] initWithTitle:@"提示" message:str1 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//                    }
             
                }];
             
            }
        }
            break;
#pragma  mark   -------------------银联支付---------------------
/*
        case 1:{
            //测试模式
            self.tnMode = kMode_Development;
            [self startNetWithURL:[NSURL URLWithString:kURL_TN_Normal]];
            //配置模式
//            self.tnMode = kMode_Development;
//            [self startNetWithURL:[NSURL URLWithString:kURL_TN_Configure]];
            //
        }
*/

            break;
#pragma  mark   --------------------微信支付--------------------
        case 1:{
            
            //创建支付签名对象
                        payRequsestHandler *req = [payRequsestHandler alloc];
                        //初始化支付签名对象
                        [req init:APP_ID mch_id:MCH_ID];
                        //设置密钥
                        [req setKey:PARTNER_ID];
            
                        //}}}
            if (pdr_amount!=NULL) {
                _orderId =rechargeDictionary[@"pay_sn"] ; //订单ID（由商家自行制定）
                _price=rechargeDictionary[@"pdr_amount"];
                _body=[NSString stringWithFormat:@"充值%@元",pdr_amount];
            }
            NSLog(@"%@",_body);
                        //获取到实际调起微信支付的参数后，在app端调起支付
                        NSMutableDictionary *dict = [req sendPay_demo_pysn:_orderId price:_price body:_body];
            
                        if(dict == nil){
                                //错误提示
                                NSString *debug = [req getDebugifo];
                
//                                [self alert:@"提示信息" msg:debug];
                
                                NSLog(@"%@\n\n",debug);
                            }else{
                                    NSLog(@"%@\n\n",[req getDebugifo]);
                                    //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
                    
                                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    
                                    //调起微信支付
                                    PayReq* req             = [[PayReq alloc] init];
                                    req.openID              = [dict objectForKey:@"appid"];
                                    req.partnerId           = [dict objectForKey:@"partnerid"];
                                    req.prepayId            = [dict objectForKey:@"prepayid"];
                                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                                    req.timeStamp           = stamp.intValue;
                                    req.package             = [dict objectForKey:@"package"];
                                    req.sign                = [dict objectForKey:@"sign"];
                                
                                    [WXApi sendReq:req];
                                }
            
            
        }
            
            break;
#pragma  mark   -------------------财付通支付---------------------
//        case 3:{
//            
//        }
//
//            break;
//    }
    }

}

/*
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
   alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [alter show];
    
}
 */
- (void)viewWillAppear:(BOOL)animated
{

}
- (void)wxPayReslut:(id)sender
{
    HostViewController *orderlist = [[HostViewController alloc] init];                        [self.navigationController pushViewController:orderlist animated:YES];}


/*
 #pragma mark UPPayPluginResult
 - (void)UPPayPluginResult:(NSString *)result
 {
 NSString* msg = [NSString stringWithFormat:kResult, result];
 [self showAlertMessage:msg];
 }
 
 - (void)startNetWithURL:(NSURL *)url
 {
 [self showAlertWait];
 
 NSURLRequest * urlRequest=[NSURLRequest requestWithURL:url];
 NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
 [urlConn start];
 }
 
 - (void)showAlertWait
 {
 [self hideAlert];
 _alertView = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
 [_alertView show];
 UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
 aiv.center = CGPointMake(_alertView.frame.size.width / 2.0f - 15, _alertView.frame.size.height / 2.0f + 10 );
 [aiv startAnimating];
 [_alertView addSubview:aiv];
 
 }
 
 - (void)showAlertMessage:(NSString*)msg
 {
 [self hideAlert];
 _alertView = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:self cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
 [_alertView show];
 
 }
 - (void)hideAlert
 {
 if (_alertView != nil)
 {
 [_alertView dismissWithClickedButtonIndex:0 animated:NO];
 _alertView = nil;
 }
 }
 
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 _alertView = nil;
 }
 #pragma mark - connection
 
 - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
 {
 NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
 NSInteger code = [rsp statusCode];
 if (code != 200)
 {
 
 [self showAlertMessage:kErrorNet];
 [connection cancel];
 }
 else
 {
 _responseData = [[NSMutableData alloc] init];
 }
 }
 
 - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
 {
 [_responseData appendData:data];
 }
 
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection
 {
 [self hideAlert];
 NSString* tn = [[NSMutableString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
 if (tn != nil && tn.length > 0)
 {
 NSLog(@"tn=%@",tn);
 [UPPayPlugin startPay:tn mode:self.tnMode viewController:self delegate:self];
 }
 }
 
 -(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
 {
 [self showAlertMessage:kErrorNet];
 }
 
 */
@end
