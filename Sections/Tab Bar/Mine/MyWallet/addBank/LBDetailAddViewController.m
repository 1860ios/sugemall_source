//
//  LBDetailAddViewController.m
//  SuGeMarket
//  添加银行卡个人信息
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBDetailAddViewController.h"
#import "UtilsMacro.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import <FXBlurView.h>
#import <UIImageView+WebCache.h>

static NSString *cid = @"cid";
@interface LBDetailAddViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *drawalView,*nameView,*peopleIdView,*phoneView,*araView;
    UILabel *kaihuLabel,*drawalNumLabel, *nameLabel,*peopleIdLabel,*bankNumLabel;
    UITextField *_nameTextField,*_idTextField,*_bankNumTextField;
    UIButton *saveButton;
    UIImageView *bankIcon;
    NSMutableArray *opBankDatas;
    UIButton *cancelButton;
    FXBlurView *bankView;
    UILabel *bankName;
    NSString *bank_id,*bname,*province,*city,*subbranch,*branch_code;
    NSArray *provinceArray,*areaArray,*subbranchArray;
    NSMutableDictionary *dic;
}
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, retain) UITextField *_provinceTextField;
@property (nonatomic, retain) UITextField *_cityTextField;
@property (nonatomic, retain) UITextField *_subbranchTextField;
@property (nonatomic, strong) UIPickerView *_pickerView;
@property (nonatomic, strong) UIPickerView *_pickerView1;
@property (nonatomic, strong) UIPickerView *_pickerView2;
@end

@implementation LBDetailAddViewController
@synthesize _tableView;
@synthesize _provinceTextField;
@synthesize _cityTextField;
@synthesize _subbranchTextField;
@synthesize _pickerView;
@synthesize _pickerView1;
@synthesize _pickerView2;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.97];
    self.title=@"添加银行卡";
    [self initBankTableView];
    [self initMyDetailView];
    [self initPickerView];
}

- (void)initBankTableView
{
    bankView = [[FXBlurView alloc] initWithFrame:self.view.bounds];
    [bankView setBlurRadius:7];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.center.x-(SCREEN_WIDTH*4/5)/2, self.view.center.y-(SCREEN_HEIGHT*2/3)/2, SCREEN_WIDTH*4/5, SCREEN_HEIGHT*2/3-40) style:UITableViewStylePlain];
        tableView.delegate =self;
        tableView.dataSource =self;
        tableView;
    });
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];

    _tableView.tableFooterView = [UIView new];
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame =CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y + _tableView.frame.size.height, _tableView.frame.size.width, 40);
    [cancelButton setBackgroundColor:APP_COLOR];
    [cancelButton setTitle:@"取消" forState:0];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:0];
    [cancelButton addTarget:self action:@selector(removeBankView) forControlEvents:UIControlEventTouchUpInside];
    [bankView addSubview:_tableView];
    [bankView addSubview:cancelButton];
}
//初始化pickView
- (void)initPickerView
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    _pickerView.tag = PICKERVIEW_TAG;
    _pickerView.delegate = self;
    
    
    _pickerView1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    _pickerView1.tag = PICKERVIEW_TAG+1;
    _pickerView1.delegate = self;
    
    _pickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    _pickerView2.tag = PICKERVIEW_TAG+2;
    _pickerView2.delegate = self;
    
}
#pragma mark **************pickView代理方法*****************************
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == PICKERVIEW_TAG) {
    return provinceArray.count;
    }else if (pickerView.tag == PICKERVIEW_TAG+1){
            return areaArray.count;
    }else if (pickerView.tag == PICKERVIEW_TAG+2){
        
        return subbranchArray.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == PICKERVIEW_TAG) {
        return provinceArray[row];
    }else if (pickerView.tag == PICKERVIEW_TAG+1){
        return areaArray[row];
    }else if (pickerView.tag == PICKERVIEW_TAG+2){
        dic=subbranchArray[row];
        return dic[@"name"];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == PICKERVIEW_TAG) {
        province = provinceArray[row];
        _provinceTextField.text = province;}
    else if (pickerView.tag == PICKERVIEW_TAG+1){
        city =areaArray[row];
        _cityTextField.text = city;
    }else if (pickerView.tag == PICKERVIEW_TAG+2){
        dic=subbranchArray[row];
        subbranch=dic[@"name"];
        branch_code=dic[@"code"];
        _subbranchTextField.text = subbranch;
    }

}
#pragma mark textFieldDidBeginEditing

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == TEXTFEILD_TAG+10) {
        
        textField.inputView = _pickerView;
        [self loadAddressDatas:bname];
    }else if (textField.tag == TEXTFEILD_TAG+11){
        
        textField.inputView = _pickerView1;
        [self loadAreaDatas:bname prv:province];
    }else if (textField.tag == TEXTFEILD_TAG+12){
        
        textField.inputView = _pickerView2;
        [self loadSubbranchDatas:bname prv:province area:city];
    }
}

- (void)removeBankView
{
    [UIView animateWithDuration:0.5 animations:^{
        [bankView removeFromSuperview];
    }];
}

-(void)initMyDetailView
{
    drawalView=[[UIView alloc]initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, 60)];
    drawalView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:drawalView];
    
    kaihuLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 30)];
    kaihuLabel.font = [UIFont systemFontOfSize:15];
    kaihuLabel.text=@"开户银行:";
    kaihuLabel.backgroundColor=[UIColor whiteColor];
    kaihuLabel.textColor = [UIColor blackColor];
    kaihuLabel.textAlignment = NSTextAlignmentLeft;
    kaihuLabel.numberOfLines = 2;
    [drawalView addSubview:kaihuLabel];

    //银行卡图标
    bankIcon=[[UIImageView alloc]initWithFrame:CGRectMake(kaihuLabel.frame.origin.x+kaihuLabel.frame.size.width,10, 40, 40)];
    bankIcon.image = IMAGE(@"dd_03_@2x");
    bankIcon.userInteractionEnabled = YES;
    [drawalView addSubview:bankIcon];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBank:)];
    [bankIcon addGestureRecognizer:tap];
    phoneView=[[UIView alloc]initWithFrame:CGRectMake(drawalView.frame.origin.x, drawalView.frame.origin.y+drawalView.frame.size.height+5, drawalView.frame.size.width, 40)];
    phoneView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:phoneView];
    
    //银行名
    bankName = [[UILabel alloc] initWithFrame:CGRectMake(bankIcon.frame.origin.x+bankIcon.frame.size.width+5, 10, 100, 30)];
    bankName.numberOfLines = 2;
    bankName.text = @"请选择银行卡";
    [bankName sizeToFit];
    [drawalView addSubview:bankName];
    
    //下标
    UIImageView *dowm = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 10, 30, 30)];
    dowm.image = IMAGE(@"bank_down");
    dowm.userInteractionEnabled = YES;
    [dowm addGestureRecognizer:tap];
    [drawalView addSubview:dowm];
    
    bankNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(phoneView.frame.origin.x+10, 0, 60, 35)];
    bankNumLabel.font = [UIFont systemFontOfSize:13];
    bankNumLabel.text=@"银行卡号:";
    bankNumLabel.textColor = [UIColor blackColor];
    bankNumLabel.textAlignment = NSTextAlignmentLeft;
    [phoneView addSubview:bankNumLabel];
    //银行卡号
    _bankNumTextField=[[UITextField alloc]initWithFrame:CGRectMake(bankNumLabel.frame.origin.x+bankNumLabel.frame.size.width+10, bankNumLabel.frame.origin.y, 250, 35)];
    _bankNumTextField.delegate = self;
    _bankNumTextField.font = [UIFont systemFontOfSize:15];
    _bankNumTextField.textColor = [UIColor blackColor];
    _bankNumTextField.keyboardType = UIKeyboardTypePhonePad;
    _bankNumTextField.textAlignment = NSTextAlignmentLeft;
    _bankNumTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _bankNumTextField.placeholder=@"请输入银行卡号";
    [phoneView addSubview:_bankNumTextField];
    
    nameView=[[UIView alloc]initWithFrame:CGRectMake(phoneView.frame.origin.x, phoneView.frame.origin.y+phoneView.frame.size.height+5, phoneView.frame.size.width, 40)];
    nameView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:nameView];
    
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameView.frame.origin.x+10, 0, 60, 35)];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.text=@"开户姓名:";
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [nameView addSubview:nameLabel];
    
    //开户姓名
    _nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+10, nameLabel.frame.origin.y, 150, 35)];
    _nameTextField.font = [UIFont systemFontOfSize:15];
    //nameTextField.text=@"Jone";
    _nameTextField.delegate = self;
    _nameTextField.placeholder=@"请输入开户姓名";
    _nameTextField.textColor = [UIColor blackColor];
    _nameTextField.textAlignment = NSTextAlignmentLeft;
    _nameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [nameView addSubview:_nameTextField];
    
    peopleIdView=[[UIView alloc]initWithFrame:CGRectMake(nameView.frame.origin.x, nameView.frame.origin.y+nameView.frame.size.height+5, nameView.frame.size.width, 40)];
    peopleIdView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:peopleIdView];

    peopleIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(peopleIdView.frame.origin.x+10, 0, 60, 35)];
    peopleIdLabel.font = [UIFont systemFontOfSize:13];
    peopleIdLabel.text=@"身份证:";
    peopleIdLabel.textColor = [UIColor blackColor];
    peopleIdLabel.textAlignment = NSTextAlignmentRight;
    [peopleIdView addSubview:peopleIdLabel];
    
    //身份证
    _idTextField=[[UITextField alloc]initWithFrame:CGRectMake(peopleIdLabel.frame.origin.x+peopleIdLabel.frame.size.width+10, peopleIdLabel.frame.origin.y, 250, 35)];
    _idTextField.delegate =self;
    _idTextField.font = [UIFont systemFontOfSize:15];
    _idTextField.textColor = [UIColor blackColor];
    _idTextField.keyboardType = UIKeyboardTypePhonePad;
    _idTextField.textAlignment = NSTextAlignmentLeft;
    _idTextField.placeholder=@"请输入开户人身份证";
    [peopleIdView addSubview:_idTextField];
    
    araView=[[UIView alloc]initWithFrame:CGRectMake(peopleIdView.frame.origin.x, peopleIdView.frame.origin.y+peopleIdView.frame.size.height+5, peopleIdView.frame.size.width, 40)];
    araView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:araView];

    _provinceTextField = [[UITextField alloc] initWithFrame:CGRectMake(araView.frame.origin.x+10,0, (SCREEN_WIDTH-10)/3, 35)];
    _provinceTextField.delegate = self;
    _provinceTextField.tag = TEXTFEILD_TAG+10;
    _provinceTextField.font = [UIFont systemFontOfSize:15];
    _provinceTextField.borderStyle = UITextBorderStyleNone;
    _provinceTextField.placeholder = @"选择省份";
    [araView addSubview:_provinceTextField];
    
    _cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(_provinceTextField.frame.origin.x+_provinceTextField.frame.size.width, _provinceTextField.frame.origin.y, _provinceTextField.frame.size.width,_provinceTextField.frame.size.height)];
    _cityTextField.delegate = self;
    _cityTextField.tag = TEXTFEILD_TAG+11;
    _cityTextField.borderStyle = UITextBorderStyleNone;
    _cityTextField.font = [UIFont systemFontOfSize:15];
    _cityTextField.placeholder = @"选择城市";
    [araView addSubview:_cityTextField];
    
    _subbranchTextField = [[UITextField alloc] initWithFrame:CGRectMake(_cityTextField.frame.origin.x+_cityTextField.frame.size.width, _cityTextField.frame.origin.y, _cityTextField.frame.size.width,_cityTextField.frame.size.height)];
    _subbranchTextField.delegate = self;
    _subbranchTextField.tag = TEXTFEILD_TAG+12;
    _subbranchTextField.borderStyle = UITextBorderStyleNone;
    _subbranchTextField.font = [UIFont systemFontOfSize:15];
    _subbranchTextField.placeholder = @"选择支行";
    [araView addSubview:_subbranchTextField];

    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton=[[UIButton alloc]initWithFrame:CGRectMake(araView.frame.origin.x+15, araView.frame.origin.y+araView.frame.size.height+10,araView.frame.size.width-25,40)];
    saveButton.backgroundColor=APP_COLOR;
    [saveButton setTitle:@"保存" forState:0];
    [saveButton addTarget:self action:@selector(saveBankCard:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:saveButton];
    
}
//选择可用银行卡
- (void)chooseBank:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
           [self.view addSubview:bankView];
    }];

    [self loadOPBankList_URL:SUGE_OPLISTBANK type:@"0"];
}
//请求地区数据
- (void)loadAddressDatas:(NSString *)bank
{
    if (!bank) {
    [TSMessage showNotificationWithTitle:@"提示" subtitle:@"请先选择银行~" type:TSMessageNotificationTypeWarning];
    }else{
    [SVProgressHUD showWithStatus:@"加载省份中..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary * parameter = nil;
    parameter = @{@"bank":bank};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    [maneger POST:SUGE_BANK_PROVINCE parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"银行卡所在省份:%@",responseObject);
        provinceArray=responseObject[@"datas"][@"province"];
        if ([provinceArray isEqual:[NSNull null]]) {
            provinceArray=@[@""];
        }
        [_pickerView reloadAllComponents];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"error:%@",error);
    }];
    [SVProgressHUD dismiss];
    }
}
- (void)loadAreaDatas:(NSString *)bank prv:(NSString *)prv
{
    if (!prv) {
        [TSMessage showNotificationWithTitle:@"提示" subtitle:@"请先填写省份~" type:TSMessageNotificationTypeWarning];
    }else{
    [SVProgressHUD showWithStatus:@"加载城市中..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary * parameter = nil;
    parameter=@{@"bank":bank,@"prv":prv};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    [maneger POST:SUGE_BANK_AREA parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"银行卡所在城市:%@",responseObject);
        areaArray=responseObject[@"datas"][@"area"];
        [_pickerView1 reloadAllComponents];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [SVProgressHUD dismiss];
    }
}
- (void)loadSubbranchDatas:(NSString *)bank prv:(NSString *)prv area:(NSString *)area
{
    if (!area) {
        [TSMessage showNotificationWithTitle:@"提示" subtitle:@"请先填写城市~" type:TSMessageNotificationTypeWarning];
    }else{
    [SVProgressHUD showWithStatus:@"加载支行中..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary * parameter = nil;
    parameter=@{@"bank":bank,@"prv":prv,@"area":area};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    [maneger POST:SUGE_BANK_SUBBRANCH parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"银行卡所在支行:%@",responseObject);
        subbranchArray=responseObject[@"datas"];
        [_pickerView2 reloadAllComponents];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [SVProgressHUD dismiss];
    }
}

//请求数据
- (void)loadOPBankList_URL:(NSString *)url type:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary * parameter = nil;
    if ([type isEqualToString:@"0"]) {
        parameter = @{@"key":key};
    }else if ([type isEqualToString:@"1"]){
         parameter = @{@"key":key,@"bank_id":bank_id,@"bankcard_number":_bankNumTextField.text,@"account_name":_nameTextField.text,@"id_card":_idTextField.text,@"branch_name":subbranch,@"branch_code":branch_code};
    }
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    [maneger POST:url parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        if ([type isEqualToString:@"0"]) {
            NSLog(@"可用银行卡:%@",responObject);
            opBankDatas = responObject[@"datas"];
            [_tableView reloadData];
    
        }else if ([type isEqualToString:@"1"]){
            NSLog(@"添加银行卡:%@",responObject);
            
            if ([responObject[@"datas"] isEqual:@"1"]){
                [SVProgressHUD showSuccessWithStatus:@"添加银行成功" maskType:SVProgressHUDMaskTypeClear];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
            });
            }else{
                NSString *error = responObject[@"datas"][@"error"];
                [[[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }
        }
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
    }];
    //dimiss HUD
    [SVProgressHUD dismiss];
}
//保存银行卡
- (void)saveBankCard:(UIButton *)btn
{
    if (_bankNumTextField.text.length==0||_idTextField.text.length == 0||_nameTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没填写完全呢~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }else{
    
    BOOL isOk = [self validateIdentityCard:_idTextField.text];
    BOOL isOk1 = [self validateBankCardNumber:_bankNumTextField.text];
    
    if (isOk&&isOk1) {
        [self loadOPBankList_URL:SUGE_ADDBANK type:@"1"];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写正确的银行卡信息!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
    }
}


//身份证号
- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//银行卡
- (BOOL) validateBankCardNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return opBankDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:opBankDatas[row][@"bank_logo"]] placeholderImage:IMAGE(@"dd_03_@2x")];
    cell.textLabel.text = opBankDatas[row][@"bank_name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [bankIcon sd_setImageWithURL:[NSURL URLWithString:opBankDatas[row][@"bank_logo"]] placeholderImage:IMAGE(@"dd_03_@2x")];
    bankName.text = opBankDatas[row][@"bank_name"];
    bname=bankName.text;
    bank_id = opBankDatas[row][@"bank_id"];
    [self removeBankView];
}

@end
