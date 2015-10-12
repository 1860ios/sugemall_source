//
//  LBInvoiceAddViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/29.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBInvoiceAddViewController.h"
#import "SUGE_API.h"
#import "AppMacro.h"
#import "UtilsMacro.h"
#import "LBUserInfo.h"
#import "TSMessage.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "MobClick.h"


@interface LBInvoiceAddViewController()<UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *invTitleSelectArray;
    NSMutableArray *_contents;
}
//@property (nonatomic, strong) UIScrollView *_scrollView;
@property (nonatomic, retain) UITextField *addInvoice;

@property (nonatomic, strong) UIPickerView *invTitleSelect;
@property (nonatomic, strong) UIPickerView *invContent;
@property (nonatomic, strong) UIView *pickerViewBG;

//发票内容
//@property (nonatomic, strong) ;

@end

@implementation LBInvoiceAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加发票";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self loadScrollView];    
    [self initSubViews];
    [self addButton];
    [self loadPickerView];
}

#pragma mark loadPickerView
- (void)loadPickerView
{
    _invTitleSelect = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    _invTitleSelect.delegate = self;
    _invTitleSelect.dataSource = self;
    _invTitleSelect.tag = PICKERVIEW_TAG;
    _pickerViewBG = [[UIView alloc] initWithFrame:_invTitleSelect.frame];
    _pickerViewBG.backgroundColor = [UIColor whiteColor];

    invTitleSelectArray = @[@"个人",@"单位"];
    
    _invContent = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    _invContent.delegate = self;
    _invContent.dataSource = self;
    _invContent.tag = PICKERVIEW_TAG+1;
    _pickerViewBG = [[UIView alloc] initWithFrame:_invContent.frame];
    _pickerViewBG.backgroundColor = [UIColor whiteColor];
}


#pragma mark initSubViews
- (void)initSubViews
{
    NSArray *names = @[@"发票类型",@"发票内容",@"发票抬头"];
    
    for (int i = 0; i < 3; i++) {
        //
//<<<<<<< Updated upstream
        _addInvoice = [[UITextField alloc] initWithFrame:CGRectMake(10, (10+i*50)+63, SCREEN_WIDTH-10, 50)];
//=======
        _addInvoice = [[UITextField alloc] initWithFrame:CGRectMake(10, 60+i*50, SCREEN_WIDTH-10, 50)];
//>>>>>>> Stashed changes
        _addInvoice.delegate = self;
        _addInvoice.tag = TEXTFEILD_TAG+i;
        _addInvoice.borderStyle = UITextBorderStyleNone;
        _addInvoice.placeholder = [names objectAtIndex:i];
//        _addInvoice.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:_addInvoice];
        if (_addInvoice.tag == TEXTFEILD_TAG+1) {
            _addInvoice.returnKeyType = UIReturnKeyDone;
        }
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60+i*50, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineView];
    }
    
}

#pragma mark 保存发票
- (void)addButton
{
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    
    UIButton * add_button = [UIButton buttonWithType:UIButtonTypeCustom];
    add_button.frame = CGRectMake(barView.center.x-80, barView.center.y-18, 160, 30);
    add_button.layer.cornerRadius = 15;
    [add_button setTitle:@"保存" forState:0];
    add_button.titleLabel.font = [UIFont systemFontOfSize:18];
    [add_button setBackgroundColor:APP_COLOR];
    [add_button setTitleColor:[UIColor whiteColor] forState:0];
    [add_button addTarget:self action:@selector(addNewInvoice) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:barView];
    [self.view addSubview:add_button];
    
}



#pragma mark 添加发票
- (void)addNewInvoice
{
    //参数
    UITextField *t1 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG];//
    UITextField *t2 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG+1];//
    UITextField *t3 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG+2];//
    
    if (t1.text.length ==0||t2.text.length ==0||t3.text.length ==0) {
        [TSMessage showNotificationWithTitle:@"错误" subtitle:@"请正确填写发票信息" type:TSMessageNotificationTypeWarning];
    }else{
        //提示
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        NSDictionary *parameter =@{@"key":key,@"inv_title_select":t1.text,@"inv_title":t3.text,@"inv_content":t2.text};
        [manager POST:SUGE_INVOICE_ADD parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            
            NSLog(@"responObject:%@",responObject);
            //miss提示
            [SVProgressHUD dismiss];
            
            [TSMessage showNotificationWithTitle:@"添加成功" type:TSMessageNotificationTypeSuccess];
            
            [self.navigationController  popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
            NSLog(@"error:%@",error);
        }];
    }
}
#pragma mark  添加发票内容
- (void)loadInvoiceContent
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"key":key};
    [manager POST:SUGE_INVOICE_CONTENT_LIST parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        
        NSLog(@"responObject:%@",responObject);
        _contents = [[NSMutableArray alloc] init];
        _contents = responObject[@"datas"][@"invoice_content_list"];
        [_invContent reloadAllComponents];
        //miss提示
        [SVProgressHUD dismiss];
        
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"error:%@",error);
    }];
}

#pragma mark textFieldDidBeginEditing
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == TEXTFEILD_TAG) {
        textField.inputView = _invTitleSelect;
    }
    if (textField.tag == TEXTFEILD_TAG +1) {
        
        [self loadInvoiceContent];
        textField.inputView = _invContent;
    }
    
}
#pragma mark - UIPicker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == PICKERVIEW_TAG) {
            return 2;
    }else if(pickerView.tag == PICKERVIEW_TAG+1){
            return _contents.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == PICKERVIEW_TAG) {
        return [invTitleSelectArray objectAtIndex:row];
    }else if(pickerView.tag == PICKERVIEW_TAG+1){
        return [_contents objectAtIndex:row];
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == PICKERVIEW_TAG) {
        
        UITextField *t1 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG];
        t1.text = [invTitleSelectArray objectAtIndex:[_invTitleSelect selectedRowInComponent:0]];

    }else if(pickerView.tag == PICKERVIEW_TAG+1){
        UITextField *t2 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG+1];
        t2.text = [_contents objectAtIndex:[_invContent selectedRowInComponent:0]];

    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [_invContent removeFromSuperview];
//    [_invTitleSelect removeFromSuperview];
    UITextField *t3 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG+2];//
    [t3 resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *t3 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG+2];//
    [t3 resignFirstResponder];
    return YES;
}

#pragma mark  ---统计页面

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"添加新发票"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"添加新发票"];
}

@end
