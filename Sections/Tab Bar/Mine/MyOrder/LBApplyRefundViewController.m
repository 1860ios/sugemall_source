//
//  LBApplyRefundViewController.m
//  SuGeMarket
//
//  申请退款
//  Created by 1860 on 15/7/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBApplyRefundViewController.h"
#import "UtilsMacro.h"
#import "SVProgressHUD.h"
#import <AFNetworking.h>
#import "SUGE_API.h"
#import <TSMessage.h>
#import "LBUserInfo.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

@interface LBApplyRefundViewController ()<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *refundArray,*reasonArray;
    UIView *view1,*view2,*view3,*view4,*view,*view5;
    UILabel *_chooseLabel,*reasonLabel,*beizhuLabel,*addLabel,*picturenumLabel;
    UIPickerView *pickerView1,*pickerView2;
    UITextField *refundField,*reasonField;
    UITextView *beizhuField;
    UIButton *addButton,*refundButton;
    UIImageView *_goodImageView;
    UILabel *_goodsnumLabel;
    UILabel *_goodsnumLabel1;
    UILabel *_showLabel;
//    UILabel *_timeLabel;
    UILabel *_ordernumLabel;
    UILabel *_priceLabel;
    NSData *imageData;
    UIImage *imageNew;
    UIImage *image;
    NSMutableArray *imageArray;
    //
    NSString *refund_num;
    NSString *refund_goods_id;
    NSString *refund_amount;
    NSString *refund_order_id;
    NSString *refund_paysn;
//    NSString *time;
    NSString *show;
    NSString *goodimage;
}
@property (nonatomic, strong) UITextView *feedback;

@end

@implementation LBApplyRefundViewController
@synthesize refundDic;
/*
@synthesize refund_order_id;
@synthesize time;
@synthesize show;
@synthesize refund_num;
@synthesize goodimage;
@synthesize refund_amount;
@synthesize refund_goods_id;
@synthesize refund_paysn;
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self getRefundData];

    [self initApplyRefundView];

}

- (void)getRefundData
{

    self.title = @"申请退款";
    self.tabBarController.tabBar.translucent = YES;
//    self.navigationController.navigationBar.translucent = YES;
    imageArray = [[NSMutableArray alloc] init];
    refundArray=@[@"退款",@"退货"];
    reasonArray=@[@"未收到货",@"尺寸不对",@"颜色偏差"];
    self.view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.97];

    refund_paysn = refundDic[@"paysn"];
    refund_order_id = refundDic[@"orderid"];
    refund_goods_id = refundDic[@"goodsid"];
    refund_num = refundDic[@"num"];
    refund_amount = refundDic[@"amount"];
    show = refundDic[@"show"];
    goodimage = refundDic[@"goodimage"];
}


#pragma mark 上传图片
- (void)pickerPic:(UIButton *)btn
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"上传手机中的照片", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];

}

#pragma mark =======上传头像======
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            //拍照上传
            [self openCamera];
        }else if (buttonIndex == 1){
            //上传手机上的照片
            [self setHeadImage];
        }else{
            return;
        }
    }
}

-(void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"你的手机不支持拍照！");
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
-(void)setHeadImage
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
//点击相册中的图片 或照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    //初始化imageNew为从相机中获得的--
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [imageArray addObject:image];
    for (int i = 0; i<imageArray.count; i++) {
        UIImageView *image1 = (UIImageView *)[self.view viewWithTag:991+i];
        image1.image = imageArray[i];
    }
     [picker dismissViewControllerAnimated:YES completion:nil];
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)_image scaledToSize:(CGSize)newSize
{

    UIGraphicsBeginImageContext(newSize);
    
    [_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


//点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark 申请退款

- (void)requestRefund
{
    if (imageArray.count == 0) {
        [self requestRefundNoPIC];
    }else{
        [self loadRefundPIC];
    }
    
}

-(void)loadRefundPIC
{

    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //
    NSString *s1 = refundField.text;
    NSString *s2 = reasonField.text;
    NSString *type = nil;
    if ([s1 isEqualToString:@"退款"]) {
        type = @"1";
    }else if ([s2 isEqualToString:@"退货"]){
        type = @"2";
    }
   NSDictionary *parameters = @{@"key":key,@"refund_amount":refund_amount,@"goods_num":refund_num,@"reason_id":s2,@"refund_type":type,@"buyer_message":beizhuField.text,@"refund_pic1":@"refund_pic11",@"refund_pic2":@"refund_pic22",@"refund_pic3":@"refund_pic33",@"order_id":refund_order_id,@"goods_id":refund_goods_id};
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:SUGE_ADD_REFUND parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSArray *arrayPic = @[@"refund_pic1",@"refund_pic2",@"refund_pic3"];
            for (int i = 0; i<imageArray.count; i++) {
                //设置image的尺寸
                CGSize imagesize = image.size;
                imagesize.height =600;
                imagesize.width =600;
                //对图片大小进行压缩--
                imageNew = [self imageWithImage:imageArray[i] scaledToSize:imagesize];
                imageData = UIImageJPEGRepresentation(imageNew,0.00001);
                // 往formData中追加文件内容
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"i%@.png", str];
                [formData appendPartWithFileData:imageData name:arrayPic[i] fileName:fileName mimeType:@"image/png"];
            }
       
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"申请退换货:%@",responseObject);
        if ([responseObject[@"datas"] isEqual:@"1"]) {
            [TSMessage showNotificationWithTitle:@"申请成功~" type:TSMessageNotificationTypeSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *error = responseObject[@"datas"][@"error"];
            NSLog(@"申请退换货错误:%@",error);
            [TSMessage showNotificationWithTitle:error type:TSMessageNotificationTypeError];
        }
    }];
    
    [uploadTask resume];


}

- (void)requestRefundNoPIC
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    //
    NSString *s1 = refundField.text;
    NSString *s2 = reasonField.text;
    NSString *type = nil;
    if ([s1 isEqualToString:@"退款"]) {
        type = @"1";
    }else if ([s2 isEqualToString:@"退货"]){
        type = @"2";
    }
    NSDictionary *parameters = @{@"key":key,@"refund_amount":refund_amount,@"goods_num":refund_num,@"reason_id":s2,@"refund_type":type,@"buyer_message":beizhuField.text,@"order_id":refund_order_id,@"goods_id":refund_goods_id};
    [maneger POST:SUGE_ADD_REFUND parameters:parameters success:^(AFHTTPRequestOperation *op,id responObject){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"申请退换货:%@",responObject);
        if ([responObject[@"datas"] isEqual:@"1"]) {
            [TSMessage showNotificationWithTitle:@"申请成功~" type:TSMessageNotificationTypeSuccess];
        }else{
            NSString *error = responObject[@"datas"][@"error"];
            [TSMessage showNotificationWithTitle:error type:TSMessageNotificationTypeError];
        }
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"网络错误:%@",error);
    }];
}

-(void)initApplyRefundView
{
    view1=[[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 35)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    view2=[[UIView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y+view1.frame.size.height+1, SCREEN_WIDTH, 100)];
    view2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view2];
    
    view3=[[UIView alloc]initWithFrame:CGRectMake(0, view2.frame.origin.y+view2.frame.size.height+1, SCREEN_WIDTH, 130)];
    view3.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view3];
    
    view4=[[UIView alloc]initWithFrame:CGRectMake(0, view3.frame.origin.y+view3.frame.size.height+10, SCREEN_WIDTH, 100)];
    view4.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view4];
    
    
    //订单编号
    _ordernumLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0, 300, 35)];
    _ordernumLabel.font = [UIFont systemFontOfSize:12];
    _ordernumLabel.textColor = [UIColor blackColor];
    _ordernumLabel.textAlignment = NSTextAlignmentLeft;
    _ordernumLabel.text=refund_paysn;
    [view1 addSubview:_ordernumLabel];
        //商品图片
    _goodImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10, 80, 80)];
    [view2 addSubview:_goodImageView];
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:goodimage] placeholderImage:IMAGE(@"dd_03_@2x")];
    //商品名称
    _showLabel=[[UILabel alloc]initWithFrame:CGRectMake(_goodImageView.frame.origin.x+_goodImageView.frame.size.width+10,_goodImageView.frame.origin.y-10, 200, 45)];
    _showLabel.font = [UIFont systemFontOfSize:15];
    _showLabel.textColor = [UIColor blackColor];
    _showLabel.textAlignment = NSTextAlignmentLeft;
    [_showLabel setNumberOfLines:2];
    _showLabel.text=show;
    [view2 addSubview:_showLabel];
    //价格
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_showLabel.frame.origin.x,_showLabel.frame.origin.y+_showLabel.frame.size.height, 100, 30)];
    _priceLabel.font = [UIFont systemFontOfSize:15];
    _priceLabel.textColor = [UIColor blackColor];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.text=refund_amount;
    [view2 addSubview:_priceLabel];
    //商品数量
    _goodsnumLabel1=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120,_showLabel.frame.origin.y+_showLabel.frame.size.height, 40, 20)];
    _goodsnumLabel1.font = [UIFont systemFontOfSize:15];
    _goodsnumLabel1.textColor = [UIColor blackColor];
    _goodsnumLabel1.textAlignment = NSTextAlignmentRight;
    _goodsnumLabel1.text=@"数量×";
    [view2 addSubview:_goodsnumLabel1];
    //商品数量
    _goodsnumLabel=[[UILabel alloc]initWithFrame:CGRectMake(_goodsnumLabel1.frame.origin.x+_goodsnumLabel1.frame.size.width,_goodsnumLabel1.frame.origin.y, 50, 20)];
    _goodsnumLabel.font = [UIFont systemFontOfSize:15];
    _goodsnumLabel.textColor = [UIColor blackColor];
    _goodsnumLabel.textAlignment = NSTextAlignmentRight;
    _goodsnumLabel.text=refund_num;
    [view2 addSubview:_goodsnumLabel];
    
    _chooseLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,5, 80, 35)];
    _chooseLabel.font = [UIFont systemFontOfSize:15];
    _chooseLabel.textColor = [UIColor blackColor];
    _chooseLabel.text=@"选择类型";
    _chooseLabel.textAlignment = NSTextAlignmentLeft;
    [view3 addSubview:_chooseLabel];
    
    reasonLabel=[[UILabel alloc]initWithFrame:CGRectMake(_chooseLabel.frame.origin.x,_chooseLabel.frame.origin.y+_chooseLabel.frame.size.height, 80, 35)];
    reasonLabel.font = [UIFont systemFontOfSize:15];
    reasonLabel.textColor = [UIColor blackColor];
    reasonLabel.text=@"退款理由";
    reasonLabel.textAlignment = NSTextAlignmentLeft;
    [view3 addSubview:reasonLabel];
    
    refundField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90,_chooseLabel.frame.origin.y, 80, 35)];
    refundField.delegate = self;
    refundField.tag = 1;
    refundField.borderStyle = UITextBorderStyleNone;
    refundField.text = @"退款";//
    refundField.textAlignment=NSTextAlignmentRight;
    [view3 addSubview:refundField];
    //下划线
    view=[[UIView alloc]initWithFrame:CGRectMake(0, refundField.frame.origin.y+refundField.frame.size.height, SCREEN_WIDTH, 1)];
    view.backgroundColor=[UIColor colorWithWhite:0.97 alpha:0.97];
    [view3 addSubview:view];
    
    
    reasonField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110,reasonLabel.frame.origin.y, 100, 35)];
    reasonField.delegate = self;
    reasonField.tag = 2;
    reasonField.borderStyle = UITextBorderStyleNone;
    reasonField.text = @"未收到货";
    reasonField.textAlignment=NSTextAlignmentRight;
    [view3 addSubview:reasonField];
    
    //下划线
    view5=[[UIView alloc]initWithFrame:CGRectMake(0, reasonField.frame.origin.y+reasonField.frame.size.height, SCREEN_WIDTH, 1)];
    view5.backgroundColor=[UIColor colorWithWhite:0.97 alpha:0.97];
    [view3 addSubview:view5];
    
    pickerView1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    pickerView1.tag=1;
    pickerView1.delegate = self;
    // [view3 addSubview:pickerView1];
    
    pickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    pickerView2.tag=2;
    pickerView2.delegate = self;
    //[view3 addSubview:pickerView2];
    
    beizhuLabel=[[UILabel alloc]initWithFrame:CGRectMake(reasonLabel.frame.origin.x,reasonLabel.frame.origin.y+reasonLabel.frame.size.height+10, 45, 35)];
    beizhuLabel.font = [UIFont systemFontOfSize:15];
    beizhuLabel.textColor = [UIColor blackColor];
    beizhuLabel.text=@"备注";
    beizhuLabel.textAlignment = NSTextAlignmentLeft;
    [view3 addSubview:beizhuLabel];
    
    beizhuField = [[UITextView alloc] initWithFrame:CGRectMake(reasonLabel.frame.origin.x+reasonLabel.frame.size.width,beizhuLabel.frame.origin.y, SCREEN_WIDTH-beizhuLabel.frame.size.width-60, 35)];
    beizhuField.textColor = [UIColor blackColor];
    beizhuField.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体
    beizhuField.delegate =self;
    // beizhuField.layer.borderColor = [UIColor redColor].CGColor;
    beizhuField.layer.cornerRadius = 6.0;//通过该值来设置textView边角的弧度
    beizhuField.layer.masksToBounds = YES;
    beizhuField.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    beizhuField.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth; ;//自适应高度
    beizhuField.scrollEnabled = YES;//是否可以拖动
    [view3 addSubview:beizhuField];
    /*
    addLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,view4.frame.size.height/4, 100, 35)];
    addLabel.font = [UIFont systemFontOfSize:15];
    addLabel.textColor = [UIColor blackColor];
    addLabel.textAlignment = NSTextAlignmentLeft;
    addLabel.text=@"添加图片";
    [view4 addSubview:addLabel];
    */
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(20,view4.frame.size.height/4, 50, 50);
    addButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [addButton setImage:IMAGE(@"add_pic") forState:0];
    [addButton addTarget:self action:@selector(pickerPic:) forControlEvents:UIControlEventTouchUpInside];
    [view4 addSubview:addButton];
    
    picturenumLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,addButton.frame.origin.y+addButton.frame.size.height-10, 100, 35)];
    picturenumLabel.font = [UIFont systemFontOfSize:12];
    picturenumLabel.textColor = [UIColor lightGrayColor];
    picturenumLabel.textAlignment = NSTextAlignmentLeft;
    picturenumLabel.text=@"(最多可添加三张)";
    [view4 addSubview:picturenumLabel];

    
  
    //三个图
    for (int i = 0; i<3; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(addButton.frame.origin.x+addButton.frame.size.width+30+(i * 65), addButton.frame.origin.y, 60, 60)];
//        imageV.backgroundColor = [UIColor yellowColor];
        imageV.tag = 991+i;
        [view4 addSubview:imageV];
    }
    
    
    /**
     *  申请退款
     */
    refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refundButton.frame = CGRectMake(0, SCREEN_HEIGHT-49-63, SCREEN_WIDTH, 49);
    refundButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [refundButton setTitle:@"提交退款申请" forState:0];
    refundButton.backgroundColor=APP_COLOR;
    [refundButton addTarget:self action:@selector(requestRefund) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refundButton];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 1) {
        textField.inputView = pickerView1;
    }
    else if(textField.tag==2)
        textField.inputView = pickerView2;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        return refundArray.count;
    }
    return reasonArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        return refundArray[row];
    }
    return reasonArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        refundField.text = refundArray[row];
    }else if (pickerView.tag==2)
        reasonField.text=reasonArray[row];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [pickerView1 removeFromSuperview];
    [pickerView2 removeFromSuperview];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    refundDic = nil;
}



@end
