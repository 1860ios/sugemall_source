//
//  LBValidateIdViewController.m
//  SuGeMarket
//  验证身份证
//  Created by 1860 on 15/10/26.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBValidateIdViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import "SVProgressHUD.h"
#import <AFNetworking.h>
#import "TSMessage.h"
#import "ZCTradeView.h"
#import "ZCTradeInputView.h"
@interface LBValidateIdViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    UIView *view;
    UITextField * _textField;
    NSString *name;
    NSString *idCard;
    UIButton *nextTepButton;
    UIButton *sendButton;
    NSString *psw;
    NSString *psw1;
    ZCTradeView *pswVC;
    ZCTradeInputView *ctrade;
    UITextField  *codeField;

}
@property(nonatomic,strong)UIScrollView *_scrollView;
@end

@implementation LBValidateIdViewController
@synthesize _scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"找回密码";
    [self loadScrollView];
    [self initTopView];
    [self initPhoneView];
}
#pragma mark loadScrollView
-(void)loadScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor=[UIColor colorWithWhite:0.98 alpha:0.93];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+50);
    [self.view addSubview:_scrollView];
}
-(void)initTopView
{
        NSArray *namesArray1 = @[@"姓名",@"证件号"];
        NSArray *namesArray2 = @[@"请输入真实姓名",@"请输入身份证号码"];
       UILabel * exlpainLable=[[UILabel alloc]initWithFrame:CGRectMake(10,10,SCREEN_WIDTH, 30)];
        exlpainLable.textAlignment=NSTextAlignmentLeft;
        exlpainLable.text=@"为保证账户安全,需要验证身份信息";
        [_scrollView addSubview:exlpainLable];
    
    view=[[UIView alloc]initWithFrame:CGRectMake(0, exlpainLable.frame.origin.y+exlpainLable.frame.size.height+10, SCREEN_WIDTH, 100)];
    view.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:view];
    
        for (int i = 0; i < 2; i++) {
            //姓名
            UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,i*50, 100, 50)];
            addressLabel.text=[namesArray1 objectAtIndex:i];
            addressLabel.textAlignment=NSTextAlignmentLeft;
            [view addSubview:addressLabel];
            //证件号
           _textField = [[UITextField alloc] initWithFrame:CGRectMake(addressLabel.frame.origin.x+addressLabel.frame.size.width,addressLabel.frame.origin.y, SCREEN_WIDTH-10-50, 50)];
            _textField.delegate = self;
            _textField.tag = TEXTFEILD_TAG+i;
            _textField.placeholder=namesArray2[i];
            _textField.borderStyle = UITextBorderStyleNone;
            _textField.textAlignment=NSTextAlignmentLeft;
            _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [_textField addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
            [view addSubview:_textField];

            //分割线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,50, SCREEN_WIDTH, 1)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:lineView];
        }
}

-(void)initPhoneView
{
    //手机号码
    UILabel *phoneLable=[[UILabel alloc]initWithFrame:CGRectMake(10,view.frame.origin.y+view.frame.size.height+15,130, 30)];
    phoneLable.textAlignment=NSTextAlignmentLeft;
    phoneLable.font=FONT(14);
    phoneLable.text=@"验证绑定手机号码";
    phoneLable.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:phoneLable];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, phoneLable.frame.origin.y+phoneLable.frame.size.height+10, SCREEN_WIDTH, 50)];
    view1.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:view1];
    //验证码
    UILabel *codeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0, 100, 50)];
    codeLabel.textColor=[UIColor blackColor];
    codeLabel.text=@"验证码";
    codeLabel.textAlignment=NSTextAlignmentLeft;
    [view1 addSubview:codeLabel];
    //验证码
   codeField = [[UITextField alloc] initWithFrame:CGRectMake(codeLabel.frame.origin.x+codeLabel.frame.size.width, codeLabel.frame.origin.y, SCREEN_WIDTH-20-150, 50)];
    codeField.delegate = self;
    codeField.placeholder=@"请输入验证码";
    [codeField addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    codeField.borderStyle = UITextBorderStyleNone;
    codeField.tag=TEXTFEILD_TAG+2;
    codeField.textAlignment=NSTextAlignmentLeft;
    codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view1 addSubview:codeField];

    sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame=CGRectMake(SCREEN_WIDTH-110,codeField.frame.origin.y+5, 100, 40);
    [sendButton setTitle:@"点击发送" forState:0];
    sendButton.layer.cornerRadius=5;
    [sendButton addTarget:self action:@selector(loadSafeDatas) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitleColor:[UIColor whiteColor] forState:0];
    sendButton.backgroundColor =[UIColor lightGrayColor];
    [view1 addSubview:sendButton];
    
    nextTepButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextTepButton.frame=CGRectMake(20,view1.frame.origin.y+view1.frame.size.height+50, SCREEN_WIDTH-40, 50);
    nextTepButton.layer.cornerRadius=5;
    [nextTepButton setTitle:@"下一步" forState:0];
    [nextTepButton addTarget:self action:@selector(clickVaildate) forControlEvents:UIControlEventTouchUpInside];
    [nextTepButton setTitleColor:[UIColor whiteColor] forState:0];
    nextTepButton.backgroundColor =[UIColor lightGrayColor];
    [_scrollView addSubview:nextTepButton];
}
- (void)getVercode
{
    //HUD
    [SVProgressHUD showWithStatus:@"发送验证码..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *key  = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSDictionary *parameters = @{@"key":key,@"mobile":_numString};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [manager POST:SUGE_SEND_VCODE parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
        
        NSLog(@"获取验证码responObject:%@,%@",responObject,responObject[@"datas"][@"error"]);
        [self kGetVVcode];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        
    }];
    [SVProgressHUD dismiss];
}
- (void)kGetVVcode
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                sendButton.userInteractionEnabled = YES;
                //                    [self getVercode];
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                [sendButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                sendButton.titleLabel.font = FONT(13);
                sendButton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}
-(void)change:(UITextField *)textField
{
    NSString *code;
    if (textField.tag==TEXTFEILD_TAG) {
        name=textField.text;
    }else if(textField.tag==TEXTFEILD_TAG+1)
    {
        idCard=textField.text;
    }else if(textField.tag==TEXTFEILD_TAG+2)
    {
        code=textField.text;
     }
    if (name.length!=0&&idCard.length!=0&&code.length!=0) {
        nextTepButton.backgroundColor =[UIColor redColor];
    }else{
        nextTepButton.backgroundColor =[UIColor grayColor];
    }
}
-(void)clickVaildate
{
    psw  = nil;
    pswVC=[[ZCTradeView alloc]init];
    ctrade=[[ZCTradeInputView alloc]init];
    ctrade.otherTitle=@"请输入原始密码";
    [pswVC show];
    __weak typeof(self) weakSelf = self;
    
    pswVC.finish = ^(NSString *passWord){
        psw = passWord;
       [weakSelf clickAppear];
    };
}
-(void)clickAppear
{
    psw1  = nil;
    pswVC=[[ZCTradeView alloc]init];
    [pswVC show];
    __weak typeof(self) weakSelf = self;
    
    pswVC.finish = ^(NSString *passWord){
        psw1 = passWord;
        [weakSelf setPassword];
    };
}
-(void)setPassword
{
    [SVProgressHUD showWithStatus:@"验证手机号..." maskType:SVProgressHUDMaskTypeClear];
    NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"key":key,@"mobile":_numString,@"vcode":codeField.text,@"password":psw,@"confirm_password":psw1};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [manager POST:SUGE_SET_PAY_MM parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
        
        NSLog(@"设置支付密码:responObject:%@",responObject);
        
        if ([responObject[@"datas"] isEqual:@"1"]) {
            [TSMessage showNotificationWithTitle:@"提示" subtitle:@"设置支付密码成功" type:TSMessageNotificationTypeSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *error = responObject[@"datas"][@"error"];
            [TSMessage showNotificationWithTitle:@"错误提示" subtitle:error type:TSMessageNotificationTypeError];
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        
    }];
    [SVProgressHUD dismiss];

}
-(void)loadSafeDatas
{
    [SVProgressHUD showWithStatus:@"正在验证身份..." maskType:SVProgressHUDMaskTypeClear];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter=@{@"key":key,@"name":name,@"idcard":idCard};
    [manager POST:SUGE_VALIDATEID parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"身份证号和姓名验证%@",responseObject);
        NSNumber *i=responseObject[@"datas"];
        if ([i intValue]==0) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"核对失败,请输入真实姓名与证件号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            _textField.text=@"";
        }else if([i intValue]==1)
        {
            NSLog(@"认证成功");
            [self getVercode];
        }else if([i intValue]==2)
        {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未实名认证,请先实名认证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];

        }
        [SVProgressHUD dismiss];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
@end
