//
//  LBNewAddressView.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/27.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBNewAddressView.h"
#import "LBMyAddressViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "AFNetworking.h"
#import "LBUserInfo.h"
#import "SVProgressHUD.h"
#import "TSMessage.h"
#import "AppMacro.h"
#import "NotificationMacro.h"
#import "MobClick.h"
#import "LBAreaListModel.h"
#import <MJExtension.h>
#import "LBAreaModel.h"
#import "UIView+Extension.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LBNewAddressView ()<UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate>
{
    LBAreaListModel *modelArea;
    LBAreaModel *model;
    
    NSString *id1;
    NSString *id2;
    NSString *isEnable;
    UIButton *setDefaultButton;
    
    CLLocationManager *locationManager;
    
    UIView *view;

}
@property (nonatomic, strong) UIScrollView *_scrollView;
@property (nonatomic, retain) UITextField *add_address;

@property (nonatomic, retain) UITextField *t1;
@property (nonatomic, retain) UITextField *t2;
@property (nonatomic, retain) UITextField *t3;
@property (nonatomic, retain) UITextField *detailText;
@property (nonatomic, assign) NSString *area_id;

@property (nonatomic, strong) UIPickerView *_pickerView;
@property (nonatomic, strong) UIPickerView *_pickerView1;
@property (nonatomic, strong) UIPickerView *_pickerView2;
@property (nonatomic, strong) UIView *_coverView;

//data
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;


@end

@implementation LBNewAddressView
@synthesize _pickerView;
@synthesize _pickerView1;
@synthesize _pickerView2;
@synthesize _coverView;
@synthesize area_id;
@synthesize isEdict;
@synthesize address_id;
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (__navTitle == nil) {
        self.title = @"新建收货地址";
    }else{
        self.title = __navTitle;
    }

    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self loadScrollView];
    [self initDetailAddress];
    [self initAddressText];
    [self addButton];
    [self initPickerView];

}

#pragma mark pickerView

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

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return model.area_list.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    modelArea = model.area_list[row];
    return modelArea.area_name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    modelArea = model.area_list[row];
    area_id = modelArea.area_id;
    if (pickerView.tag == PICKERVIEW_TAG) {
        
        _t1.text = modelArea.area_name;
    }else if (pickerView.tag == PICKERVIEW_TAG+1){
        id1 = area_id;
        _t2.text = modelArea.area_name;
    }else if (pickerView.tag == PICKERVIEW_TAG+2){
        id2 = area_id;
        _t3.text = modelArea.area_name;
    }
   

}


#pragma mark 添加保存button

- (void)addButton
{
    
    UIButton * add_button = [UIButton buttonWithType:UIButtonTypeCustom];
    add_button.frame = CGRectMake(20,view.frame.origin.y+view.frame.size.height+20, SCREEN_WIDTH-40, 50);
    [add_button setTitle:@"保存" forState:0];
    add_button.titleLabel.font = [UIFont systemFontOfSize:18];
    [add_button setBackgroundColor:[UIColor redColor]];
    [add_button setTitleColor:[UIColor whiteColor] forState:0];
    [add_button addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add_button];

}

- (void)addNewAddress
{
    NSString *url;
    if (isEdict) {
        url = SUGE_ADDRESS;
    }else{
        url = SUGE_ADDRESS_ADD;
    }
    [self addNewAddress:url addressID:address_id];
}

#pragma mark loadScrollView
-(void)loadScrollView
{
    __scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63+5*50+10)];
    __scrollView.delegate = self;
    __scrollView.alwaysBounceVertical = YES;
    __scrollView.directionalLockEnabled = YES;
    __scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+50);
    __scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:__scrollView];
}

#pragma mark initSubViews
- (void)initAddressText
{
//    NSArray *names = @[@"收货人",@"电话号码",@"手机",@"地区信息",@"详细地址信息"];
    NSArray *names = @[@"*收货人姓名:",@"*联系电话:"];
    NSArray *texts = [[NSArray alloc] init];
    
    
    for (int i = 0; i < 2; i++) {
        UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+i*50, 100, 50)];
        addressLabel.text=[names objectAtIndex:i];
        addressLabel.textColor=[UIColor grayColor];
        NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:names[i]];
        [str4 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
        addressLabel.attributedText = str4;
        addressLabel.textAlignment=NSTextAlignmentLeft;
        [__scrollView addSubview:addressLabel];
        
        _add_address = [[UITextField alloc] initWithFrame:CGRectMake(addressLabel.frame.origin.x+addressLabel.frame.size.width, 10+i*50, SCREEN_WIDTH-10-50, 50)];
        _add_address.delegate = self;
        _add_address.tag = TEXTFEILD_TAG+i;
        _add_address.borderStyle = UITextBorderStyleNone;
        _add_address.textAlignment=NSTextAlignmentLeft;
        _add_address.clearButtonMode = UITextFieldViewModeWhileEditing;
        [__scrollView addSubview:_add_address];
        //判断当前text值为空不
        if (__address != nil) {
//            texts=  @[__trueName,__telPhone,__mobPhone,__areaInfo,__address];
            texts=  @[__trueName,__telPhone];
            _add_address.text = [texts objectAtIndex:i];
            _detailText.text = __address;
        }

        if (_add_address.tag == TEXTFEILD_TAG+1) {
            _add_address.keyboardType = UIKeyboardTypeNumberPad;
        }if (_add_address.tag == TEXTFEILD_TAG+2) {
            _add_address.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60+i*50, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [__scrollView addSubview:lineView];
    }
    
}

#pragma mark 省市区text
- (void)initDetailAddress
{
    UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(10,10+2*50, 50, 50)];
    l1.textColor=[UIColor grayColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"*省:"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    l1.attributedText = str;
    l1.textAlignment=NSTextAlignmentLeft;
    [__scrollView addSubview:l1];
    
    _t1 = [[UITextField alloc] initWithFrame:CGRectMake(l1.frame.origin.x+l1.frame.size.width, l1.frame.origin.y, SCREEN_WIDTH/3-60, 50)];
    _t1.delegate = self;
    _t1.tag = TEXTFEILD_TAG+10;
    _t1.borderStyle = UITextBorderStyleNone;
    [__scrollView addSubview:_t1];
    
    UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(_t1.frame.origin.x+_t1.frame.size.width, _t1.frame.origin.y, 50, 50)];
    l2.textColor=[UIColor grayColor];
    l2.textAlignment=NSTextAlignmentLeft;
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"*市:"];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    l2.attributedText = str2;
    [__scrollView addSubview:l2];
    
    _t2 = [[UITextField alloc] initWithFrame:CGRectMake(l2.frame.origin.x+l2.frame.size.width, _t1.frame.origin.y, _t1.frame.size.width,_t1.frame.size.height)];
    _t2.delegate = self;
    _t2.tag = TEXTFEILD_TAG+11;
    _t2.borderStyle = UITextBorderStyleNone;
   // _t2.placeholder = @"选择城市";
    [__scrollView addSubview:_t2];
    
    UILabel *l3=[[UILabel alloc]initWithFrame:CGRectMake(_t2.frame.origin.x+_t2.frame.size.width, _t2.frame.origin.y, 50, 50)];
    l3.textColor=[UIColor grayColor];
    l3.textAlignment=NSTextAlignmentLeft;
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:@"*区:"];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    l3.attributedText = str3;
    [__scrollView addSubview:l3];

    
    _t3 = [[UITextField alloc] initWithFrame:CGRectMake(l3.frame.origin.x+l3.frame.size.width, _t2.frame.origin.y, _t2.frame.size.width,_t2.frame.size.height)];
    _t3.delegate = self;
    _t3.tag = TEXTFEILD_TAG+12;
    _t3.borderStyle = UITextBorderStyleNone;
   // _t3.placeholder = @"选择区或县";
    [__scrollView addSubview:_t3];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 3*50+10, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [__scrollView addSubview:lineView];
    
    //详细地址信息
    _detailText= [[UITextField alloc] initWithFrame:CGRectMake(10, 10+3*50, (SCREEN_WIDTH-10), 50)];
    _detailText.delegate = self;
    _detailText.borderStyle = UITextBorderStyleNone;
    _detailText.returnKeyType = UIReturnKeyDone;
    _detailText.placeholder = @"填写详细信息,不需要再填写省市区";
    _detailText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [__scrollView addSubview:_detailText];
    
    
    UIButton *locationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame=CGRectMake(SCREEN_WIDTH/2-80, 10+4*50,20, 50);
    [locationButton setImage:IMAGE(@"123") forState:0];
    [locationButton addTarget:self action:@selector(clickLocation) forControlEvents:UIControlEventTouchUpInside];
    [__scrollView addSubview:locationButton];
    
    UILabel *locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(locationButton.frame.origin.x+locationButton.frame.size.width, locationButton.frame.origin.y, 150, 50)];
    locationLabel.textColor=[UIColor blackColor];
    locationLabel.textAlignment=NSTextAlignmentLeft;
    locationLabel.font=FONT(15);
    locationLabel.text=@"定位到当前地址";
    [__scrollView addSubview:locationLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 4*50+10, SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [__scrollView addSubview:lineView2];
    
    //分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10+5*50, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [__scrollView addSubview:lineView1];
    
    view=[[UIView alloc]initWithFrame:CGRectMake(0,__scrollView.frame.origin.y+__scrollView.frame.size.height+20, SCREEN_WIDTH, 50)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
  setDefaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setDefaultButton.frame=  CGRectMake(0,0, 50, 50);
//    [setDefaultButton setTag:[addressListModel.address_id integerValue]];
    [setDefaultButton setImage:IMAGE(@"syncart_round_check1@2x") forState:0];
    [setDefaultButton setImage:IMAGE(@"syncart_round_check2@2x") forState:UIControlStateSelected];
    [setDefaultButton setTag:[_setTag integerValue]];
    [setDefaultButton addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:setDefaultButton];

//    //判断是否默认地址
//    if ([addressListModel.is_default isEqualToString:@"1"]) {
//       // address.text = [NSString stringWithFormat:@"[默认]%@",add];
//        setDefaultButton.selected  =YES;
//    }
    
    
    UILabel *setDefaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(setDefaultButton.frame.origin.x+setDefaultButton.frame.size.width, setDefaultButton.frame.origin.y, 80, 50)];
    setDefaultLabel.font = FONT(15);
    setDefaultLabel.text = @"设为默认";
    [view addSubview:setDefaultLabel];
    
}
-(void)setDefaultAddress:(UIButton *)btn
{
    NSInteger row = btn.tag;
    NSString *row1 = [NSString stringWithFormat:@"%ld",(long)row];
    NSLog(@"address_row:%@",row1);
    setDefaultButton.selected=YES;
    isEnable=@"1";
//    [self LoadAddressURL:@"http://sugemall.com/mobile/index.php?act=member_address&op=address_set_default" address_id:row1 type:@"default"];
    

}
//- (void)LoadAddressURL:(NSString *)url address_id:(NSString *)add_id type:(NSString *)type
//{
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
//    //登陆key
//    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
//    NSDictionary *parameter =@{@"key":key,@"address_id":add_id};
//    NSLog(@"dgdg");
//    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
//        NSLog(@"responObject:%@",responObject);
//        responObject[@"datas"]=@"1";
//        if ([responObject[@"datas"] isEqualToString:@"1"]) {
//            
//            //再次请求数据
//          //  [self loadDatas];
//        }
//    } failure:^(AFHTTPRequestOperation *op,NSError *error){
//    }];
//    [SVProgressHUD dismiss];
//    
//}
#pragma mark textFieldDidBeginEditing

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    if (textField.tag == TEXTFEILD_TAG+10) {
//        [_coverView addSubview:_pickerView];
        textField.inputView = _pickerView;
//        [self.view addSubview:_coverView];
        [self loadAddressDatas:@"" boo:@"1"];
    }else if (textField.tag == TEXTFEILD_TAG+11){
//        [_coverView addSubview:_pickerView1];
//        [self.view addSubview:_coverView];
        textField.inputView = _pickerView1;
        [self loadAddressDatas:area_id boo:@"2"];
    }else if (textField.tag == TEXTFEILD_TAG+12){
//        [_coverView addSubview:_pickerView2];
//        [self.view addSubview:_coverView];
        textField.inputView = _pickerView2;
        [self loadAddressDatas:area_id boo:@"3"];
    }
}

#pragma mark 请求地区数据

- (void)loadAddressDatas:(NSString *)areaID boo:(NSString *)boo
{
    if(!areaID){
        [TSMessage showNotificationWithTitle:@"提示" subtitle:@"请先填写省份~" type:TSMessageNotificationTypeWarning];
    }else{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"key":key,@"area_id":areaID};
    [manager POST:SUGE_AREA_LIST parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
                NSLog(@"key:%@",key);
        NSLog(@"area_id_responObject:%@",responObject);

        model = [LBAreaModel objectWithKeyValues:responObject[@"datas"]];
        if ([boo isEqualToString:@"1"]) {
            [_pickerView reloadAllComponents];
        }else if ([boo isEqualToString:@"2"]){
            [_pickerView1 reloadAllComponents];
        }else if ([boo isEqualToString:@"3"]){
            [_pickerView2 reloadAllComponents];
        }
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"error:%@",error);
    }];
    }
}

#pragma mark 添加地址
- (void)addNewAddress:(NSString *)url addressID:(NSString *)addressID
{
    //参数
    UITextField *t1 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG];//收货人
    UITextField *t2 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG+1];//电话
//    UITextField *t3 = (UITextField *)[self.view viewWithTag:TEXTFEILD_TAG+2];//手机

    NSString *address = [NSString stringWithFormat:@"%@%@%@",_t1.text,_t2.text,_t3.text];

    
    if (t1.text.length ==0||_t1.text.length == 0||_t3.text.length == 0||_detailText.text.length == 0) {
        [TSMessage showNotificationWithTitle:@"错误" subtitle:@"请正确填写地址信息" type:TSMessageNotificationTypeWarning];
    }else{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        NSDictionary *parameter;
        if (isEdict){
            parameter=@{@"key":key,@"address_id":addressID,@"true_name":t1.text,@"city_id":id1,@"area_id":id2,@"area_info":address,@"address":_detailText.text,@"tel_phone":t2.text};
        }else{
            parameter=@{@"key":key,@"true_name":t1.text,@"city_id":id1,@"area_id":id2,@"area_info":address,@"address":_detailText.text,@"tel_phone":t2.text};

        }
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        //SUGE_ADDRESS_ADD SUGE_ADDRESS
        if (isEdict) {
        NSLog(@"修改地址responObject:%@",responObject);
        [TSMessage showNotificationWithTitle:@"修改成功" type:TSMessageNotificationTypeSuccess];
        }else{
        NSLog(@"增加地址responObject:%@",responObject);
        [TSMessage showNotificationWithTitle:@"添加成功" type:TSMessageNotificationTypeSuccess];
        }
        NSLog(@"%@",isEnable);
        if(self.block){
        self.block(isEnable);
        }
        [self.navigationController  popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"error:%@",error);
    }];
        //miss提示
        [SVProgressHUD dismiss];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_detailText resignFirstResponder];
    return YES;
}
-(void)clickLocation
{
    locationManager=[[CLLocationManager alloc]init];
    if([CLLocationManager locationServicesEnabled]){
        NSLog(@"StartingCLLocationManager");
        locationManager.delegate=self;
        locationManager.distanceFilter=200;
        [locationManager requestAlwaysAuthorization];//添加这句
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }else{
        NSLog(@"CannotStartingCLLocationManager");
    }
}
//-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
//{
//    NSLog(@"sdf");
//}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSArray *a;
        a=placemark.addressDictionary[@"FormattedAddressLines"];
        NSLog(@"详细信息:%@,%@,%@,%@,%@,%@,%@",placemark.addressDictionary[@"City"],a[0],placemark.addressDictionary[@"State"],placemark.addressDictionary[@"Street"],placemark.addressDictionary[@"SubLocality"],placemark.addressDictionary[@"SubThoroughfare"],placemark.addressDictionary[@"Thoroughfare"]);
        _detailText.text=a[0];
    }];

}

//定位
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMsg = nil;
    if ([error code] == kCLErrorDenied) {
        errorMsg = @"访问被拒绝";
    }
    if ([error code] == kCLErrorLocationUnknown) {
        errorMsg = @"获取位置信息失败";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Location"
                                                      message:errorMsg delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark 统计页面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"添加新地址"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];

    [MobClick endLogPageView:@"添加新地址"];
}
//
@end
