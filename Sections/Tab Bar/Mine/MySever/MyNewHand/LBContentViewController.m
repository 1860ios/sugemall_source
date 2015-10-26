//
//  LBContentViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/19.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBContentViewController.h"
#import "LBArticlesViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import <UIImageView+WebCache.h>
static NSString *cid=@"cid";
@interface LBContentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *thirdListArray;
    NSString *article_id;
}
@property(nonatomic,strong)UITableView *_tableView;
@end

@implementation LBContentViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self loadDatas];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_ac_id compare:@"17"]) {
        return 44;
    }
    return 110;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return thirdListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cid];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([_ac_id compare:@"17"]) {
    cell.textLabel.text=[thirdListArray objectAtIndex:indexPath.row][@"article_title"];
     article_id=thirdListArray[indexPath.row][@"article_id"];

    }else
    {
        article_id=thirdListArray[indexPath.row][@"article_id"];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 150,90)];
        [imageView sd_setImageWithURL:[thirdListArray objectAtIndex:indexPath.row][@"article_cover"] placeholderImage:IMAGE(@"")];
        imageView.backgroundColor=[UIColor redColor];
        [cell.contentView addSubview:imageView];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10,imageView.frame.origin.y,SCREEN_HEIGHT-imageView.frame.size.width-10,25)];
        nameLabel.text=thirdListArray[indexPath.row][@"article_title"];
        nameLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:nameLabel];
        UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x,nameLabel.frame.origin.y+nameLabel.frame.size.height+40,SCREEN_HEIGHT-160,25)];
        numLabel.text=[NSString stringWithFormat:@"%@ 人看过",thirdListArray[indexPath.row][@"article_views"]];
        numLabel.textColor=[UIColor lightGrayColor];
        numLabel.font=FONT(14);
        numLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:numLabel];
        
        UIButton *sharebutton=[UIButton buttonWithType:UIButtonTypeCustom];
        sharebutton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, numLabel.frame.origin.y, 100, 25)];
        sharebutton.backgroundColor=[UIColor redColor];
        [cell.contentView addSubview:sharebutton];
    
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBArticlesViewController *article=[[LBArticlesViewController alloc]init];
    article.article_id=article_id;
    [self.navigationController pushViewController:article animated:YES];
}
- (void)loadDatas
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"ac_id":_ac_id,@"page":@"1"};
    NSString *url=[NSString string];
    if ([_ac_id compare:@"17"]) {
        url=SUGE_CONTENT;
    }else{
        url=SUGE_VIDEO;
    }
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"datas"]);
        if (![responseObject[@"datas"] isKindOfClass:[NSString class]]) {
            if ([_ac_id compare:@"17"]) {
                thirdListArray=responseObject[@"datas"][@"article_list"];
            }else{
                thirdListArray=responseObject[@"datas"][@"video_list"];
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [SVProgressHUD dismiss];
}

@end
