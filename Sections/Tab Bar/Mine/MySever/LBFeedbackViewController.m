//
//  LBFeedbackViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/4.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBFeedbackViewController.h"
#import "UtilsMacro.h"
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import <AFNetworking.h>
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import "MobClick.h"

@interface LBFeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *feedback;
@property (nonatomic, retain) UIButton *submit;

@end

@implementation LBFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    
    [self drawView];
}

#pragma mark drawView
- (void)drawView
{
    self.view.backgroundColor = [UIColor whiteColor];
    //
    _feedback = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, SCREEN_WIDTH-20, 200)];
    _feedback.textColor = [UIColor blackColor];
    _feedback.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体
    _feedback.delegate =self;
    
    _feedback.layer.borderColor = [UIColor redColor].CGColor;
    _feedback.layer.borderWidth =1.0;//该属性显示外边框
    _feedback.layer.cornerRadius = 6.0;//通过该值来设置textView边角的弧度
    _feedback.layer.masksToBounds = YES;
    _feedback.backgroundColor = [UIColor whiteColor];
    _feedback.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth; ;//自适应高度
    _feedback.scrollEnabled = YES;//是否可以拖动
    [self.view addSubview:_feedback];
    
    
    //
    _submit = [UIButton buttonWithType:UIButtonTypeCustom];
    _submit.frame = CGRectMake(_feedback.frame.origin.x, _feedback.frame.origin.y+_feedback.frame.size.height+10, _feedback.frame.size.width, 50);
    [_submit setTitle:@"提交反馈" forState:0];
    [_submit setTitleColor:[UIColor redColor] forState:0];
    _submit.layer.cornerRadius = 5;
    _submit.layer.masksToBounds = YES;
    _submit.layer.borderWidth = 1;
    _submit.layer.borderColor = [[UIColor redColor] CGColor];
    [_submit addTarget:self action:@selector(submitFeedback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submit];
}

#pragma mark submitFeedback
- (void)submitFeedback
{
    if (!_feedback.text.length) {
        [TSMessage showNotificationWithTitle:@"请重新输入" type:TSMessageNotificationTypeWarning];
    }else{
        //提示
        [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeClear];
        //key
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        //text
        NSString *feedback = _feedback.text;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        NSDictionary *parameter =@{@"key":key,@"feedback":feedback};
        [manager POST:SUGE_FEEDBACK_ADD parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            NSLog(@"order_group_list_responObject:%@",responObject);
            NSLog(@"key%@",key);
            //miss提示
            [SVProgressHUD showSuccessWithStatus:@"提交成功" maskType:SVProgressHUDMaskTypeClear];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
            NSLog(@"error:%@",error);
        }];
        
    
    }
    
}

#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"意见反馈"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"意见反馈"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
