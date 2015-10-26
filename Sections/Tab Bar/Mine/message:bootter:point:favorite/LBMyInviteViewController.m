//
//  LBMyInviteViewController.m
//  SuGeMarket
//
//  我的推荐人
//  Created by 1860 on 15/7/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMyInviteViewController.h"
#import "UtilsMacro.h"
#import "SVProgressHUD.h"
#import <AFNetworking.h>
#import <TSMessage.h>
#import "LBUserInfo.h"
#import "SUGE_API.h"

@interface LBMyInviteViewController ()<UITextFieldDelegate>
{
    UITextField *inviteField;
    UILabel *nameLabel;
    UIButton *edictInviteButton;
    UIView *lin1;
}
@end

@implementation LBMyInviteViewController
//@synthesize isInvite;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改推荐人";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadMyInviteView];
}

- (void)loadMyInviteView
{
    inviteField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 40)];
    inviteField.delegate = self;
    inviteField.borderStyle = UITextBorderStyleNone;
    inviteField.placeholder = @"请输入上级幸运号";
    inviteField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:inviteField];
    lin1 = [[UIView alloc] initWithFrame:CGRectMake(20, 60-1, SCREEN_WIDTH-40, 1)];
    lin1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lin1];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(inviteField.frame.origin.x,inviteField.frame.origin.y+inviteField.frame.size.height+20,inviteField.frame.size.width,30)];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.textColor = APP_COLOR;
    [self.view addSubview:nameLabel];
    nameLabel.hidden = YES;
    
    edictInviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    edictInviteButton.frame = CGRectMake(nameLabel.frame.origin.x,nameLabel.frame.origin.y+nameLabel.frame.size.height+20,nameLabel.frame.size.width,40);
//    if (isInvite) {
//    edictInviteButton.enabled = NO;
//    [edictInviteButton setBackgroundColor:[UIColor lightGrayColor]];
//    }else{
//    edictInviteButton.enabled = YES;
//    [edictInviteButton setBackgroundColor:APP_COLOR];
//    }
    [edictInviteButton setBackgroundColor:APP_COLOR];
    [edictInviteButton setTitle:@"提交修改" forState:0];
    [edictInviteButton setTitleColor:[UIColor whiteColor] forState:0];
    [edictInviteButton addTarget:self action:@selector(edictMyInvite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:edictInviteButton];
}

- (void)edictMyInvite
{
    NSString *t1 = inviteField.text;
    if (t1.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没输入幸运号呢~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }else{
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        NSDictionary *parameter =@{@"key":key,@"uid":t1};
        [manager POST:SUGE_SET_INVITER parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            NSLog(@"设置上级:%@",responObject);
            [TSMessage showNotificationWithTitle:@"设置成功~" type:TSMessageNotificationTypeSuccess];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
            NSLog(@"error:%@",error);
        }];
    

    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    lin1.backgroundColor = APP_COLOR;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSString *t1 = inviteField.text;
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"key":key,@"uid":t1};
    [manager POST:SUGE_SEARCH_USER parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"查找:%@",responObject);
        NSDictionary *dic1 =responObject[@"datas"];
        NSArray *k1 = [dic1 allKeys];
        if ([k1[0] isEqual:@"name"]) {
            nameLabel.text = [NSString stringWithFormat:@"用户:%@",responObject[@"datas"][@"name"]];
        }else{
            nameLabel.text = @"没有该用户!";
        }
        nameLabel.hidden = NO;
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"error:%@",error);
    }];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
}

@end
