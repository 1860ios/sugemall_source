//
//  LBNewsViewController.m
//  SuGeMarket
//
//  消息
//  Created by 1860 on 15/10/22.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBNewsViewController.h"
#import "UtilsMacro.h"
#import "LBBaseMethod.h"
#import "AppMacro.h"
#import <UIImageView+WebCache.h>
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import "LBLognInViewController.h"
#import "LBAddressListViewController.h"
#import "LBArticleView.h"
#import "LBMessageViewController.h"

@interface LBNewsViewController ()
{
    NSMutableDictionary *newsDic;
    NSArray *keyArray;
}
@end

@implementation LBNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    keyArray = @[@"activity",@"business",@"member_msg",@"order_msg",@"system",@"wealth_msg"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark 请求消息数据
- (void)requestNewsDatas
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSDictionary *parm =@{@"key":key};
    [LBBaseMethod get:SUGE_NEWS parms:parm success:^(id json){
        NSLog(@"消息:%@",json);
        newsDic = [NSMutableDictionary dictionary];
        newsDic = json[@"datas"][@"msg_category_list"];
        [self.tableView reloadData];
    }failture:^(id error){
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return newsDic.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    NSInteger index1 = indexPath.row;
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 60, 60)];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.frame.origin.x+iconImage.frame.size.width+10, 5, 100, 40)];
    if (index1 == 0) {
        name.text = @"通讯录";
        iconImage.image = IMAGE(@"tongxunlu_01");
        name.frame = CGRectMake(iconImage.frame.origin.x+iconImage.frame.size.width+10, 15, 100, 25);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        NSDictionary *dic2 = [newsDic valueForKey:keyArray[index1-1]];
        NSString *image_url = [dic2 valueForKey:@"msg_pic"];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:IMAGE(@"")];
        name.text = [dic2 valueForKey:@"msg_name"];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x+name.frame.size.width+20, name.frame.origin.y, SCREEN_WIDTH-name.frame.origin.x-name.frame.size.width-20-15, 25)];
        label2.text = [dic2 valueForKey:@"last_time"];
        label2.textAlignment = NSTextAlignmentRight;
        label2.font = FONT(16);
        label2.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:label2];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y+name.frame.size.height, 200, 25)];
        label1.text = [dic2 valueForKey:@"last_msg"];
        label1.font = FONT(16);
        label1.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:label1];
    }
    [cell.contentView addSubview:iconImage];
    name.font = FONT(18);
    [cell.contentView addSubview:name];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(name.frame.origin.x-5, 70, SCREEN_WIDTH-name.frame.origin.x-5, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:line1];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (row == 0) {
        LBAddressListViewController *address = [LBAddressListViewController new];
        address.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:address animated:YES];
    }else{
        NSDictionary *dic2 = [newsDic valueForKey:keyArray[row-1]];
        NSString *type = [dic2 valueForKey:@"type"];
        NSString *title = [dic2 valueForKey:@"msg_name"];
        //文章
        if ([type isEqualToString:@"0"]) {
            NSString *acid = [dic2 valueForKey:@"ac_id"];
            LBArticleView *article = [[LBArticleView alloc] init];
            article.hidesBottomBarWhenPushed = YES;
            article._title =title;
            article.ac_id = acid;
            [self.navigationController pushViewController:article animated:YES];
        }
        //订单/caifu//会员
        else{
            NSString *type = keyArray[row-1];
            LBMessageViewController *message = [[LBMessageViewController alloc] init];
            message._type = type;
            message._title = title;
            message.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:message animated:YES];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    BOOL islogin = [LBUserInfo sharedUserSingleton].isLogin;
    if (islogin) {
    [self requestNewsDatas];
    }else{
        [self.navigationController pushViewController:[LBLognInViewController new] animated:YES];
    }
    
}
@end
