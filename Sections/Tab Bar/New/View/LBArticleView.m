//
//  LBArticleView.m
//  SuGeMarket
//
//  Created by Apple on 15/10/28.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBArticleView.h"
#import "LBBaseMethod.h"
#import "LBArticleCell.h"
#import "LBArticleDetailView.h"
#import <MJRefresh.h>

static NSString *const cid = @"cid";
@interface LBArticleView ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *articleDatas;
    NSString *curnum;
    int _curpage;
}
@property (nonatomic, strong) UITableView *_articleTableView;
@end

@implementation LBArticleView
@synthesize ac_id;
@synthesize _title;
@synthesize _articleTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _title;
    _curpage = 1;
    articleDatas = [NSMutableArray array];
    [self requestArticleDatas:@"1"];
    [self loadArticleTableView];
    [self setUpFooterRefresh];
}
- (void)setUpFooterRefresh
{
    [_articleTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMessageNewData)];
    // 隐藏时间
    _articleTableView.header.updatedTimeHidden = YES;
    // 设置文字
    [_articleTableView.footer setTitle:@"加载更多文章..." forState:MJRefreshFooterStateIdle];
    [_articleTableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [_articleTableView.footer setTitle:@"到头了~" forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    _articleTableView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    _articleTableView.header.textColor = APP_COLOR;
}

- (void)loadMessageNewData
{
    _curpage++;
    curnum = [NSString stringWithFormat:@"%d",_curpage];
    [self requestArticleDatas:curnum];
}

- (void)requestArticleDatas:(NSString *)page
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSDictionary *parms = @{@"key":key,@"ac_id":ac_id,@"page":page};
    [LBBaseMethod get:SUGE_ARTICLE parms:parms success:^(id  json){
        NSLog(@"文章数据:%@",json);
        [_articleTableView.footer endRefreshing];
        NSArray *newDatas = [NSArray array];
        newDatas = json[@"datas"][@"article_cover_list"];
        if (newDatas.count == 0) {
            [_articleTableView.footer noticeNoMoreData];
        }else{
            [articleDatas addObjectsFromArray:newDatas];
        }
        [_articleTableView reloadData];
    }failture:^(id  error){
        
    }];
}

- (void)loadArticleTableView
{
    _articleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _articleTableView.backgroundColor = RGBCOLOR(246,246,246);
    _articleTableView.dataSource = self;
    _articleTableView.delegate = self;
    [_articleTableView registerClass:[LBArticleCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_articleTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return articleDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 10, 100, 20)];
    timeLabel.text = articleDatas[section][@"article_time"];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor grayColor];
    return timeLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    LBArticleCell *cell;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cid];
    }
    cell.backgroundColor = RGBCOLOR(246,246,246);
    [cell addValueForArticleCell:articleDatas[section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    [_articleTableView deselectRowAtIndexPath:indexPath animated:YES];
    LBArticleDetailView *article = [[LBArticleDetailView alloc] init];
    NSString *str1 = [NSString stringWithFormat:@"article_id=%@",articleDatas[section][@"article_id"]];
    NSString *url = [SUGE_BASE_URL1 stringByAppendingString:str1];
    article.articleURL = [NSString stringWithFormat:@"%@",url];
    [self.navigationController pushViewController:article animated:YES];
}


@end
