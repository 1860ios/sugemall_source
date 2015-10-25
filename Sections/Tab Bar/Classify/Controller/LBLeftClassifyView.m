//
//  LBLeftClassifyView.m
//  SuGeMarket
//
//  左滑分类
//  Created by 1860 on 15/10/22.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBLeftClassifyView.h"
#import "LBBaseMethod.h"
#import "SUGE_API.h"
#import "AppMacro.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>
#import "LBClassifyViewContrtoller.h"


@interface LBLeftClassifyView (){
    NSMutableArray *datasArray;
}

@end

@implementation LBLeftClassifyView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = RGBCOLOR(41, 42, 47);
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self.tableView setSeparatorInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    self.tableView.tableFooterView = [UIView new];
    [self loadONEclassicfy];
}

- (void)loadONEclassicfy{
    [LBBaseMethod get:SUGE_1_FENLEI parms:nil success:^(id json){
        NSLog(@"一级分类:%@",json);
        datasArray = [NSMutableArray array];
        datasArray = json[@"datas"][@"class_list"];
        [self.tableView reloadData];
    }failture:^(id error){
        
    }];
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cid = @"cid";
    NSInteger index1 = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.backgroundColor = RGBCOLOR(41, 42, 47);
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 30, 30)];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:datasArray[index1][@"image"]] placeholderImage:IMAGE(@"")];
        [cell.contentView addSubview:iconImage];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.frame.origin.x+iconImage.frame.size.width+15, 5, 100, 30)];
        name.text = datasArray[index1][@"gc_name"];
        name.font = FONT(19);
        name.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:name];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *goodid = datasArray[indexPath.row][@"gc_id"];

        [self.drawer close];
        [NOTIFICATION_CENTER postNotificationName:@"pushclassify" object:nil userInfo:[NSDictionary dictionaryWithObject:goodid forKey:@"gc_id"]];

}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}


@end
