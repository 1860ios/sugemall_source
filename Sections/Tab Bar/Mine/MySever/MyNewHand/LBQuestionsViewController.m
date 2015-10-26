//
//  LBQuestionsViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/17.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBQuestionsViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "LBContentViewController.h"
#import "LBNewHandModel.h"
#import "MJExtension.h"
#import "AppMacro.h"
static NSString *cid=@"cid";
@interface LBQuestionsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *listMutableArray;
    NSMutableArray *listMutableArray1;
    LBNewHandModel *NewHandModel;
    LBNewLisiModel *listModel;
}
@property(nonatomic,strong)UITableView *_tableView;
@end

@implementation LBQuestionsViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    if ([_tag isEqual:@"0"]) {
        [self loadDatas:@"faq"];
    }else{
        [self loadDatas:@"video"];
    }
}

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorInset=UIEdgeInsetsMake(0, -11, 0,11);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_tag isEqual:@"1"]) {
        return listMutableArray1.count;
    }
    return listMutableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cid];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([_tag isEqual:@"0"]) {
        cell.textLabel.text=[listMutableArray[indexPath.row] objectForKey:@"ac_name"];
        cell.imageView.backgroundColor=[UIColor redColor];
    }
    else{
        cell.textLabel.text=[listMutableArray1[indexPath.row] objectForKey:@"ac_name"];
        cell.imageView.backgroundColor=[UIColor redColor];}
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBContentViewController *content=[[LBContentViewController alloc]init];
    listModel = NewHandModel.child[indexPath.row];

    content.ac_id=listModel.ac_id;
    NSDictionary *dic2 = @{@"ac_id":listModel.ac_id};
    
    [NOTIFICATION_CENTER postNotificationName:@"xiangqing" object:nil userInfo:dic2];
}
#pragma mark 获取数据
- (void)loadDatas:(NSString *)ac_code
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"ac_code":ac_code,@"has_child":@"1"};
    [manager POST:SUGE_NEWHAND parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"新手指引%@",responseObject);
        listMutableArray=responseObject[@"datas"][@"article_class_list"][@"faq"][@"child"];
        listMutableArray1=responseObject[@"datas"][@"article_class_list"][@"video"][@"child"];
        if (listMutableArray.count==0) {
        NewHandModel=[LBNewHandModel objectWithKeyValues:responseObject[@"datas"][@"article_class_list"][@"video"]];
        }else {
            NewHandModel=[LBNewHandModel objectWithKeyValues:responseObject[@"datas"][@"article_class_list"][@"faq"]];
        }

        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [SVProgressHUD dismiss];
}
@end
