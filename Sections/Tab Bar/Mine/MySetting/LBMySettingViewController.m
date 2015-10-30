//
//  LBMySuGeMall.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/24.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//
#import "UtilsMacro.h"
#import "LBMySettingViewController.h"
#import "SUGE_API.h"
#import <AFNetworking.h>
#import "LBUserInfo.h"
#import "MBProgressHUD.h"
#import "AppMacro.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "LBMemberInfo.h"
#import "NotificationMacro.h"
#import "SVProgressHUD.h"
#import "TSMessage.h"
#import "MobClick.h"
#import "LBInvoiceListViewController.h"
#import "LBMyAddressViewController.h"
#import "LBSafeViewController.h"
#import "SDImageCache.h"
#import "LBBlingViewController.h"
#import "LBBling1ViewController.h"
#import "LBBlingStep1lViewController.h"
#import "LBBlingStepViewController.h"
#import "LBMyQRCodeViewController.h"
static NSString *cid = @"cid";

@interface LBMySettingViewController()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    LBUserInfo *userInfo;
    LBMemberInfo *memberInfo;
    NSString *mypoint;
    UIImageView *avator;
    NSString *number;
    NSString *email;
}
@property (nonatomic, strong) UITableView *_tableView;


@end
@implementation LBMySettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawTableView];
    [self loadDatas];
    [self loadIsHaveEmail];
}


#pragma mark  加载数据
- (void)loadDatas
{
        //提示
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameter = @{@"key":key,@"client":@"ios"};
        maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        
        [maneger POST:SUGE_MY_SUGE parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            //dimiss HUD
            [SVProgressHUD dismiss];
            
            NSLog(@"responObject:%@",responObject);
            
            memberInfo = [LBMemberInfo objectWithKeyValues:responObject[@"datas"][@"member_info"]];
            mypoint = memberInfo.point;
            number=memberInfo.mobile;
            [self._tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
            NSLog(@"登陆失败:%@",error);
        }];

 }
- (void)loadIsHaveEmail
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_IS_HAV_EMAIL parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        
        NSLog(@"是否邮箱responObject:%@",responObject);
        email = responObject[@"datas"][@"email"];
        [self._tableView reloadData];
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"登陆失败:%@",error);
    }];
}
#pragma mark  drawTableView
- (void)drawTableView
{
    __tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    __tableView.delegate =self;
    __tableView.dataSource =self;
    
    //    __tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    [__tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:__tableView];
    
}
#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


#pragma mark
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cid];
    }
//    LBSafeViewController *safe = [[LBSafeViewController alloc] init];

    if (section == 0) {
        //avator
        avator = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80-40, 10, 80, 80)];
        avator.contentMode = UIViewContentModeScaleAspectFit;
        avator.layer.cornerRadius = 40;
        avator.layer.masksToBounds = YES;
        NSString *ic1 = memberInfo.avator;
         NSLog(@"avator:%@",ic1);
        [avator sd_setImageWithURL:[NSURL URLWithString:ic1] placeholderImage:IMAGE(@"user_no_image.png") options:SDWebImageRefreshCached];
            [[SDImageCache sharedImageCache] clearDisk];
        [cell.contentView addSubview:avator];
        //username
        UILabel *user = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 150, 40)];
        user.text = @"头像";
//        user.textAlignment = NSTextAlignmentCenter;
        user.textColor = [UIColor blackColor];
        user.font = [UIFont systemFontOfSize:20];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:user];
    
    }else if (section == 1){
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = memberInfo.user_name;
        //        cell.detailTextLabel.text = memberInfo.point;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (section == 2){
        cell.textLabel.text =@"手机号";
        cell.detailTextLabel.text=number;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (section == 3){
        cell.textLabel.text =@"邮箱";
        cell.detailTextLabel.text=email;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (section == 4){
        cell.textLabel.text =@"地址管理";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (section == 5){
        cell.textLabel.text =@"我的发票";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (section == 6){
        cell.textLabel.text =@"我的二维码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

#pragma mark
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0) {
            return 100;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self._tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    LBSafeViewController *safe = [[LBSafeViewController alloc] init];
    LBBlingStep1lViewController *step1=[[LBBlingStep1lViewController alloc]init];
    LBBlingStepViewController *step=[[LBBlingStepViewController alloc]init];
    LBMyQRCodeViewController *arCode=[[LBMyQRCodeViewController alloc]init];
//    NSString *mob = memberInfo.mobile;
    switch (section) {
        case 0:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"上传手机中的照片", nil];
            actionSheet.tag = 100;
            [actionSheet showInView:self.view];
        }
            break;
        case 2:
            if ([number isEqualToString:@"您还未绑定手机号"]) {
                [self.navigationController pushViewController:[LBBlingViewController new] animated:YES];
            }else{
                step.agoNumString=number;
                [self.navigationController pushViewController:step animated:YES];
                
            }
            break;
        case 3:
            if ([email isEqualToString:@"您还未绑定邮箱"] ) {
                [self.navigationController pushViewController:[LBBling1ViewController new] animated:YES];
            }else{
                step1.agoEmailString=email;
                [self.navigationController pushViewController:step1 animated:YES];
            }
            break;
   
        case 4:
            [self.navigationController pushViewController:[LBMyAddressViewController new] animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:[LBInvoiceListViewController new] animated:YES];
            break;
        case 6:

            [self.navigationController pushViewController:arCode animated:YES];
            break;
        
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"我的设置"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的设置"];
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
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //设置image的尺寸
    CGSize imagesize = image.size;
    imagesize.height =400;
    imagesize.width =400;
    //对图片大小进行压缩--
       UIImage *imageNew = [self imageWithImage:image scaledToSize:imagesize];
    NSData *imageData = UIImageJPEGRepresentation(imageNew,0.00001);


    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dict = @{@"key":key,@"pic":@"iconimage"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:SUGE_UPLOAD parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 往formData中追加文件内容
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:imageData name:@"pic" fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSError *error;
//            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"上传头像完成:%@", result);
            NSString *newfile = result[@"datas"][@"newfile"];
            [[SDImageCache sharedImageCache] clearMemory];
            [avator sd_setImageWithURL:[NSURL URLWithString:newfile] placeholderImage:IMAGE(@"") options:SDWebImageCacheMemoryOnly];
            [[SDImageCache sharedImageCache] clearMemory];
            [USER_DEFAULT setObject:nil forKey:suge_avatar];
            [USER_DEFAULT synchronize];
            [USER_DEFAULT setObject:newfile forKey:suge_avatar];
            [USER_DEFAULT synchronize];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
    }];
       /*
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:SUGE_UPLOAD parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSData *data = UIImageJPEGRepresentation(image, 1);
        // 往formData中追加文件内容
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         // 设置时间格式
         formatter.dateFormat = @"yyyyMMddHHmmss";
         NSString *str = [formatter stringFromDate:[NSDate date]];
         NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:imageData name:@"pic" fileName:fileName mimeType:@"image/png"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"上传图片res:%@,error:%@",responseObject,error);
//        if (error) {
//            UIAlertView *alertUP = [[UIAlertView alloc]initWithTitle:nil message:@"上传图片失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertUP show];
//        }else{
            NSString *newfile = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"newfile"]];
                    [[SDImageCache sharedImageCache] clearMemory];
            [avator sd_setImageWithURL:[NSURL URLWithString:newfile] placeholderImage:IMAGE(@"") options:SDWebImageCacheMemoryOnly];
            [[SDImageCache sharedImageCache] clearMemory];
            [USER_DEFAULT setObject:nil forKey:suge_avatar];
            [USER_DEFAULT synchronize];
            [USER_DEFAULT setObject:newfile forKey:suge_avatar];
            [USER_DEFAULT synchronize];
//        }
    }];
    
    [uploadTask resume];
    */
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


//点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)backMeVC
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
