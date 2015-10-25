//
//  LBSearchViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBSearchViewController.h"
#import "MobClick.h"
#import "UtilsMacro.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "LBGoodsListViewController.h"

static NSString *cid = @"cid";

@interface LBSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIView *navView;
    UITextField *searchText;
    UIButton *_cancel;
    NSMutableArray *searchMutableArray;
    NSMutableArray *recordArray;
    UIButton *deleteButton;
    NSMutableArray *m;
}
@property (nonatomic, strong) UITableView *_tableView;

@end

@implementation LBSearchViewController
@synthesize _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_Grey_COLOR;
    recordArray=[NSMutableArray array];
//    // 获取系统自带滑动手势的target对象
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    // 设置手势代理，拦截手势触发
//    pan.delegate = self;
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//    // 禁止使用系统自带的滑动手势
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self loadSearchView];
    [self loadSearchTableView];
    [self loaddeletebutton];

}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    return YES;
//}


-(void)loaddeletebutton
{
    
    deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(20,44*recordArray.count+10, _tableView.frame.size.width-40, 40);
    //NSLog(@"%f",_tableView.frame.size.height);
    //deleteButton.titleLabel.text=@"清除历史记录";
    deleteButton.layer.cornerRadius = 5;
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.borderColor = [APP_COLOR CGColor];
    [deleteButton setTitle:@"清除历史记录" forState:0];
    [deleteButton setTitleColor:APP_COLOR forState:0];
     [deleteButton addTarget:self action:@selector(delegateRecord)forControlEvents:UIControlEventTouchUpInside];
    deleteButton.backgroundColor=[UIColor whiteColor];
    [_tableView addSubview:deleteButton];
}
-(void)delegateRecord
{
    [recordArray removeAllObjects];
    [_tableView reloadData];
    deleteButton.hidden=YES;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath = [homePath stringByAppendingPathComponent:@"record.plist"];
    NSLog(@"%@",filePath);
    [manager removeItemAtPath:filePath error:nil];
    
    
}
- (void)loadSearchTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view insertSubview:_tableView belowSubview:navView];
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [_tableView setTableFooterView:view];
}

- (void)loadSearchView
{
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    navView.backgroundColor=[UIColor whiteColor];
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(10, navView.frame.origin.y+30, SCREEN_WIDTH-80, 35)];
    searchText.delegate = self;
    searchText.placeholder = @"搜索商品关键字";
    searchText.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.97];
    searchText.borderStyle = UITextBorderStyleNone;
    [searchText becomeFirstResponder];
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.leftView = [[UIImageView alloc] initWithImage:IMAGE(@"suge_search_te")];
    searchText.leftViewMode = UITextFieldViewModeAlways;
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.layer.cornerRadius = 5;
    searchText.layer.masksToBounds = YES;
    searchText.userInteractionEnabled = YES;
    _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancel.frame =CGRectMake(searchText.frame.origin.x+searchText.frame.size.width,searchText.frame.origin.y, 60, searchText.frame.size.height);
    [_cancel setTitle:@"取消" forState:0];
    [_cancel setTitleColor:[UIColor lightGrayColor] forState:0];
    [_cancel addTarget:self action:@selector(dismissView1) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:searchText];
    [navView addSubview:_cancel];
    [self.view addSubview:navView];
    
}

#pragma mark dismiss

- (void)dismissView1
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchText endEditing:YES];
    
    LBGoodsListViewController *goodsList = [[LBGoodsListViewController alloc] init];
    NSString *kk =searchText.text;
    goodsList._keyWord = kk;
    
    NSString *search=searchText.text;
    if (![search  isEqualToString: @""]) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *filePath = [homePath stringByAppendingPathComponent:@"record.plist"];
        searchMutableArray=[NSMutableArray array];
    if(![manager fileExistsAtPath:filePath])
    {
        [searchMutableArray writeToFile:filePath atomically:YES];
    }
    m =[NSMutableArray arrayWithContentsOfFile:filePath];
    
        [m addObject:search];
        [m writeToFile:filePath atomically:YES];
    }
    
    
    
   // [searchMutableArray addObject:search];
    [self.navigationController pushViewController:goodsList animated:NO];
    return YES;
}

#pragma mark- tableview - delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    //cell.textLabel.text = @"记录";

    NSArray *array = [[recordArray reverseObjectEnumerator] allObjects];
    cell.textLabel.text=[array objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (recordArray.count==0) {
        deleteButton.hidden=YES;
    }
    return recordArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    LBGoodsListViewController *goodsList = [[LBGoodsListViewController alloc] init];
   // NSString *kk =searchText.text;
    NSString *kk=[recordArray objectAtIndex:indexPath.row];
    
    NSLog(@"searchText:%@",searchText.text);
    //goodsList._keyWord =kk;
    goodsList._keyWord =kk;
    [self.navigationController pushViewController:goodsList animated:YES];
}


#pragma mark --页面统计
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath = [homePath stringByAppendingPathComponent:@"record.plist"];
    recordArray =[NSMutableArray arrayWithContentsOfFile:filePath];
    [_tableView reloadData];
    [MobClick beginLogPageView:@"搜索商品"];
    searchText.text=nil;
    [deleteButton removeFromSuperview];
    [self loaddeletebutton];
    
    LBGoodsListViewController *goodsList = [[LBGoodsListViewController alloc] init];
    goodsList.navigationController.navigationBar.backgroundColor=[UIColor blueColor];
    [goodsList.navigationItem.leftBarButtonItem setAction:@selector(popToRootViewController)];
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationItem.leftBarButtonItem setAction:@selector(poptorootViewController)];
}
-(void)popToRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"搜索商品"];
    self.navigationController.navigationBar.hidden = NO;
}

@end
