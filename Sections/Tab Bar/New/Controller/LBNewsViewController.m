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

@interface LBNewsViewController ()
{
    NSMutableDictionary *newsDic;
}
@end

@implementation LBNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
 
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
    
    return newsDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    //首先根据标识去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //如果缓存池没有到则重新创建并放到缓存池中
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSInteger index1 = indexPath.row;
        NSArray *key = @[@"activity_msg",@"order_msg",@"system_msg",@"wealth_msg"];
        NSDictionary *dic2 = [newsDic valueForKey:key[index1]];
        NSString *image_url = [dic2 valueForKey:@"msg_pic"];
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 50, 50)];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:IMAGE(@"")];
        [cell.contentView addSubview:iconImage];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.frame.origin.x+iconImage.frame.size.width+15, 10, 100, 40)];
        name.text = [dic2 valueForKey:@"msg_name"];
        name.font = FONT(20);
        [cell.contentView addSubview:name];

    }
   

    return cell;
    
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
