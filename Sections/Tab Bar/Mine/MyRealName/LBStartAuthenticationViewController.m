//
//  LBStartAuthenticationViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/17.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBStartAuthenticationViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "LBEndAutAuthenticationViewController.h"
static NSString *cid=@"cid";
#import <AFNetworking.h>
#import "LBUserInfo.h"
#import "SVProgressHUD.h"
@interface LBStartAuthenticationViewController ()<UITextFieldDelegate>
{
    UITextField *nameField;
    UITextField *idField;
    UIButton *autButton;
    NSString *name;
}
@end

@implementation LBStartAuthenticationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self initStartView];
}
#pragma mark initStartView
-(void)initStartView
{
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 20+63, 100, 35)];
    nameLabel.text=@"真实姓名:";
    nameLabel.textColor=[UIColor grayColor];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:nameLabel];
    
   nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height , SCREEN_WIDTH, 50)];
    nameField.delegate = self;
    nameField.placeholder=@"请输入与身份证姓名一致的真实姓名";
    nameField.backgroundColor=[UIColor whiteColor];
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.textAlignment=NSTextAlignmentLeft;
    [nameField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:nameField];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, nameField.frame.origin.y+nameField.frame.size.height, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithWhite:0.90 alpha:0.93];
    [self.view addSubview:lineView];
    
    UILabel *idLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, nameField.frame.origin.y+nameField.frame.size.height ,100, 40)];
    idLabel.text=@"身份证号码:";
    idLabel.textColor=[UIColor grayColor];
    idLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:idLabel];
    
    idField = [[UITextField alloc] initWithFrame:CGRectMake(0,idLabel.frame.origin.y+idLabel.frame.size.height,SCREEN_WIDTH, 50)];
    idField.delegate = self;
    idField.borderStyle = UITextBorderStyleNone;
    idField.textAlignment=NSTextAlignmentLeft;
    idField.placeholder=@"请输入真实的身份证号码";
    idField.backgroundColor=[UIColor whiteColor];
    idField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [idField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:idField];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, idField.frame.origin.y+idField.frame.size.height, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor=[UIColor colorWithWhite:0.90 alpha:0.93];
    [self.view addSubview:lineView1];
    
    autButton=[UIButton buttonWithType:UIButtonTypeCustom];
    autButton.frame=CGRectMake(10, idField.frame.origin.y+idField.frame.size.height+20, SCREEN_WIDTH-20, 55);
    [autButton setTitle:@"开始认证" forState:0];
    autButton.layer.cornerRadius = 6;
    autButton.backgroundColor=[UIColor grayColor];
    [autButton addTarget:self action:@selector(pushEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autButton];
}

-(void)textFieldChanged:(UITextField *)textField
{
    if (nameField.text.length!=0&&idField.text.length!=0) {
        autButton.backgroundColor=APP_COLOR;
    }else{
        autButton.backgroundColor=[UIColor grayColor];
    }
}
-(void)pushEnd
{
    name=nameField.text;

    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter;
        parameter = @{@"key":key,@"truename":nameField.text,@"idcard":idField.text};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_AUTHENTICATION parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        LBEndAutAuthenticationViewController *end=[[LBEndAutAuthenticationViewController alloc]init];
        end.name=nameField.text;
        end.id=idField.text;
        NSString *error=responseObject[@"datas"][@"error"];
        if (error==nil) {
            [SVProgressHUD showSuccessWithStatus:@"认证成功" maskType:SVProgressHUDMaskTypeClear];
            [self.navigationController pushViewController:end animated:YES];
        }else
        {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"认证失败" maskType:SVProgressHUDMaskTypeClear];
        NSLog(@"%@",error);
    }];
    [SVProgressHUD dismiss];
}
@end
