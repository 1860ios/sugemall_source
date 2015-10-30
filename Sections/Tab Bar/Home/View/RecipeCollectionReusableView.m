//
//  RecipeCollectionReusableView.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/19.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "RecipeCollectionReusableView.h"
#import "UtilsMacro.h"
#import "AppMacro.h"
#import <UIImageView+WebCache.h>
#import "NotificationMacro.h"
@implementation UIButton (FillColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
@interface RecipeCollectionReusableView()
{
    NSMutableArray *groupidArray;
    NSMutableArray *goodsidArray;
}
@end

@implementation RecipeCollectionReusableView
@synthesize qianggou_group_price,qianggou_imageview,qianggou_name,qianggou_price,qianggou_time,qianggou_timer_label,qianggouScrollView,_scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadReHeaderView];
    }
    return self;
}

- (void)addValueForReusableView:(NSMutableArray *)value
{
        if (value.count!=0) {
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * value.count, 164);
    for (int i = 0; i < value.count; i++) {
//        modelItem = model.item[i];
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
        UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:imageButton.frame];
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:[value objectAtIndex:i]] placeholderImage:IMAGE(@"dd_03_@2x")];
        [imageButton setBackgroundColor:[UIColor clearColor]];
        [imageButton setTag:100+i];
        [imageButton addTarget:self action:@selector(postPushImageView:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:iamgeView];
        [_scrollView addSubview:imageButton];
    }
    _pageControl.numberOfPages = value.count;
        }
}

- (void)postPushImageView:(UIButton *)btn
{
    NSInteger index = btn.tag-100;
    NSDictionary *userInfo = @{@"index":[NSNumber numberWithInteger:index]};
    [NOTIFICATION_CENTER postNotificationName:SUGE_GUANGGAO object:nil userInfo:userInfo];
}

//抢购传值
- (void)addValueForQianggouView:(NSMutableArray *)value
{
    if (!qianggou_imageview) {
        

        if (value.count!=0) {//value[i][@"groupbuy_image"]
    _pageControl_qianggou.numberOfPages = value.count;
    qianggouScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * value.count, qianggouScrollView.frame.size.height);
    for (int i = 0; i < value.count; i++) {
        UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH, 0, SCREEN_WIDTH, qianggouView.frame.size.height)];
        [qianggouScrollView addSubview:goodsView];
        //图
        qianggou_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH/2-20), (SCREEN_WIDTH/2-20))];
//        qianggou_imageview.image = IMAGE(@"suge_icon");
        [qianggou_imageview sd_setImageWithURL:[NSURL URLWithString:value[i][@"groupbuy_image"]] placeholderImage:IMAGE(@"")];
        [goodsView addSubview:qianggou_imageview];
        //名
        qianggou_name = [[UILabel alloc]initWithFrame:CGRectMake(qianggou_imageview.frame.origin.x+qianggou_imageview.frame.size.width+10, qianggou_imageview.frame.origin.y+10, SCREEN_WIDTH-qianggou_imageview.frame.size.width-15-5-15, 40)];
        qianggou_name.font = FONT(15);
        qianggou_name.numberOfLines = 2;
        qianggou_name.textColor = [UIColor lightGrayColor];
        qianggou_name.text = value[i][@"groupbuy_name"];
        [goodsView addSubview:qianggou_name];
        //价格
        qianggou_group_price = [[UILabel alloc] initWithFrame:CGRectMake(qianggou_name.frame.origin.x, qianggou_name.frame.size.height+qianggou_name.frame.origin.y+5, 100, 30)];
        qianggou_group_price.font =  FONT(25);
        qianggou_group_price.text = [NSString stringWithFormat:@"￥%@",value[i][@"groupbuy_price"]];
        qianggou_group_price.textColor = APP_COLOR;
        [goodsView addSubview:qianggou_group_price];
        //原价
        qianggou_price = [[UILabel alloc] initWithFrame:CGRectMake(qianggou_group_price.frame.origin.x+qianggou_group_price.frame.size.width, qianggou_group_price.frame.origin.y+5, SCREEN_WIDTH-qianggou_group_price.frame.origin.x-qianggou_group_price.frame.size.width-15, 20)];
        qianggou_price.textColor = [UIColor lightGrayColor];
        qianggou_price.font = FONT(13);
        qianggou_price.text = [NSString stringWithFormat:@"原价%@",value[i][@"goods_price"]];
        [goodsView addSubview:qianggou_price];
        //距离结束
        qianggou_time = [[UILabel alloc] initWithFrame:CGRectMake(qianggou_group_price.frame.origin.x, qianggou_group_price.frame.origin.y+qianggou_group_price.frame.size.height+5, 65, 20)];
        qianggou_time.font = FONT(15);
        qianggou_time.text = value[i][@"count_down_text"];
        qianggou_time.textColor = [UIColor lightGrayColor];
        [goodsView addSubview:qianggou_time];
        //倒计时
        qianggou_timer_label = [[UILabel alloc] initWithFrame:CGRectMake(qianggou_time.frame.origin.x+qianggou_time.frame.size.width, qianggou_time.frame.origin.y, 80, 20)];
        qianggou_timer = [[MZTimerLabel alloc] initWithLabel:qianggou_timer_label andTimerType:MZTimerLabelTypeTimer];
        
        NSString *count_don =  value[i][@"count_down"];
        float count_don_1 = [count_don floatValue];
        [qianggou_timer setCountDownTime:count_don_1];
        [qianggou_timer start];
        [goodsView addSubview:qianggou_timer_label];
        

        //立即抢购
        UIButton *qianggou_button = [UIButton buttonWithType:UIButtonTypeCustom];
        qianggou_button.frame = CGRectMake(qianggou_time.frame.origin.x, qianggou_time.frame.origin.y+qianggou_time.frame.size.height+10, qianggou_name.frame.size.width/2, 35);
        NSString *button_text = value[i][@"button_text"];
        [qianggou_button setBackgroundColor:APP_COLOR];
        qianggou_button.enabled = YES;
        if ([button_text isEqualToString:@"即将开始"]) {
            if (count_don_1!=0) {
                [NSTimer scheduledTimerWithTimeInterval:count_don_1 target:self selector:@selector(releaseQianggouButton:) userInfo:nil repeats:YES];
            }
        }
        [groupidArray addObject:value[i][@"groupbuy_id"]];
        [goodsidArray addObject:value[i][@"goods_id"]];
        
        [qianggou_button setTitle:button_text forState:UIControlStateNormal];
        [qianggou_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qianggou_button setTag:945+i];
        qianggou_button.layer.cornerRadius = 3;
        qianggou_button.layer.masksToBounds = YES;
        [qianggou_button addTarget:self action:@selector(postQianggou_method:) forControlEvents:UIControlEventTouchUpInside];
        [goodsView addSubview:qianggou_button];
        

            }
        }
    }
}

//后台
- (void)releaseQianggouButton:(NSTimer *)timer
{
    [NOTIFICATION_CENTER postNotificationName:@"POSTNOT_UPDATE_DATAS" object:nil];
}
//抢购
- (void)postQianggou_method:(UIButton *)btn
{
    NSInteger index = btn.tag-945;
    NSString *groupID = groupidArray[index];
    NSString *goodsID = goodsidArray[index];
    NSDictionary *dic1= @{@"goods_id":goodsID,@"groupbuy_id":groupID};
    [NOTIFICATION_CENTER postNotificationName:@"POSTGROUPDETAIL" object:nil userInfo:dic1];
    
}

- (void)addValueForZhuantiView:(NSMutableArray *)value
{
    if (value.count!=0) {
    
    zhuantiView = [[UIView alloc] initWithFrame:CGRectMake(0, qianggouView.frame.origin.y+qianggouView.frame.size.height, SCREEN_WIDTH, (value.count*(SCREEN_WIDTH*280/540)))];
    [self addSubview:zhuantiView];
    for (int i = 0; i<value.count; i++) {
        UIImageView *model4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*(SCREEN_WIDTH*280/540), SCREEN_WIDTH, SCREEN_WIDTH*280/540)];
        model4.userInteractionEnabled = YES;
        model4.tag = ZHUANTI_TAG+i;
        [model4 sd_setImageWithURL:[NSURL URLWithString:value[i]] placeholderImage:IMAGE(@"")];
        UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postPsuhHome1:)];
        [model4 addGestureRecognizer:tap];
        //    model4.backgroundColor = [UIColor cyanColor];
        [zhuantiView addSubview:model4];
    }
    [self load_bottomView];
    }
}

- (void)postPsuhHome1:(UIGestureRecognizer*)sender
{
    NSInteger index = sender.view.tag-ZHUANTI_TAG;
    NSDictionary *useInfo = @{@"index":[NSNumber numberWithInteger:index]};
    [NOTIFICATION_CENTER postNotificationName:SUGE_ZHUANTI object:nil userInfo:useInfo];
    
}

- (void)loadReHeaderView
{
    groupidArray = [NSMutableArray array];
    goodsidArray = [NSMutableArray array];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,164)];
    [self addSubview:headerView];
    [self load_scrollview];
    [self initPageControl];
    //限时抢购
    qianggouView  = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, SCREEN_WIDTH, 230)];
    [self addSubview:qianggouView];
    [self load_qianggouView];
    //专题
    


}
//瞎逛游
- (void)load_bottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, zhuantiView.frame.origin.y+zhuantiView.frame.size.height, SCREEN_WIDTH, 50)];
    [self addSubview:bottomView];
    UIView *lin1 = [[UIView alloc] initWithFrame:CGRectMake(0, 20, (SCREEN_WIDTH/2)*3/4, 1)];
    lin1.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lin1];
    UILabel *guangLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, lin1.frame.origin.y-10, 80, 20)];
    guangLabel.text = @"瞎逛游";
    guangLabel.font = FONT(20);
    guangLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:guangLabel];
    UIView *lin2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH/2)*3/4, lin1.frame.origin.y, (SCREEN_WIDTH/2)*3/4, 1)];
    lin2.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lin2];

    
}

#pragma mark 轮播图
- (void)load_scrollview
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 164)];
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * model.item.count, 164);
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.tag = 911;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [headerView addSubview:_scrollView];
}

- (void)initPageControl
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height-20, SCREEN_WIDTH, 20)];
//    _pageControl.numberOfPages = model.item.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    _pageControl.currentPage = 0;
    [headerView addSubview:_pageControl];
    
    timeCount = 0;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //    NSLog(@"%d", page);
    if (scrollView.tag == 911) {
        _pageControl.currentPage = page;
    }else{
        _pageControl_qianggou.currentPage = page;
    }
//    for (int i = 0; i<3; i++) {
//        UIButton *button2 = (UIButton *)[self viewWithTag:QIANGGOU_TAG+i];
//        button2.selected = NO;
//        //        [btn setEnabled:YES];
//    }

    
}
- (void)initPageControl_qianggou
{
    if (!_pageControl_qianggou) {
        
    _pageControl_qianggou = [[UIPageControl alloc] initWithFrame:CGRectMake(0, qianggouView.frame.size.height-20, SCREEN_WIDTH, 20)];

//    _pageControl_qianggou.numberOfPages = model.item.count;
    _pageControl_qianggou.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl_qianggou.currentPageIndicatorTintColor = [UIColor redColor];
//    [_pageControl_qianggou addTarget:self action:@selector(pageTurn_qianggou:) forControlEvents:UIControlEventValueChanged];
    _pageControl_qianggou.currentPage = 0;
    [qianggouView addSubview:_pageControl_qianggou];
    }
}
//page动画
- (void)pageTurn:(UIPageControl *)aPage
{
    NSInteger whichPage = aPage.currentPage;
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * whichPage, 0) animated:YES];
    }];
}

//自动滚动
- (void)scrollTimer
{
    timeCount ++;
    _pageControl.currentPage = timeCount;
    if (timeCount == 3) {
        timeCount =0;
        _pageControl.currentPage = timeCount;
    }
    [_scrollView scrollRectToVisible:CGRectMake(timeCount * SCREEN_WIDTH, 65.0, SCREEN_WIDTH, SCREEN_HEIGHT/3) animated:YES];
}
#pragma mark 限时抢购
- (void)load_qianggouView
{
    UILabel *qianggouLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 30)];
    qianggouLabel.text = @"限时抢购";
    [qianggouView addSubview:qianggouLabel];
    NSArray *timeButtonTitles = @[@"16:00",@"18:00",@"20:00"];
    for (int i = 0; i<3; i++) {
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        float timeButtonWidth = 60;
        float timeButtonSpacing = 5;
        timeButton.frame = CGRectMake((SCREEN_WIDTH-15-timeButtonSpacing*2-timeButtonWidth*3)+i*(timeButtonWidth+timeButtonSpacing), qianggouLabel.frame.origin.y, timeButtonWidth, 30);
        timeButton.userInteractionEnabled  = YES;
        [timeButton setBackgroundColor:APP_COLOR forState:UIControlStateSelected];
        [timeButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        timeButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        timeButton.layer.borderWidth = 0.5;
        [timeButton setTitle:timeButtonTitles[i] forState:UIControlStateNormal];
        [timeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        timeButton.layer.masksToBounds = YES;
        timeButton.layer.cornerRadius = 2;
        timeButton.tag = QIANGGOU_TAG+i;
        if (timeButton.tag == QIANGGOU_TAG) {
            timeButton.selected = YES;
        }
        [timeButton addTarget:self action:@selector(timeDuanMethod:) forControlEvents:UIControlEventTouchUpInside];
        [qianggouView addSubview:timeButton];
    }
    lineView = [[UIView alloc] initWithFrame:CGRectMake(qianggouLabel.frame.origin.x, 10+qianggouLabel.frame.size.height, SCREEN_WIDTH-30, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [qianggouView addSubview:lineView];
    //scrollview
    qianggouScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lineView.frame.origin.y+10, SCREEN_WIDTH, qianggouView.frame.size.height-(lineView.frame.origin.y+5))];
    qianggouScrollView.delegate = self;
    qianggouScrollView.tag = 912;
    qianggouScrollView.userInteractionEnabled = YES;
    qianggouScrollView.pagingEnabled = YES;
    qianggouScrollView.directionalLockEnabled = YES;
    qianggouScrollView.showsVerticalScrollIndicator = NO;
    qianggouScrollView.showsHorizontalScrollIndicator = NO;
    qianggouScrollView.bounces = NO;
    [qianggouView addSubview:qianggouScrollView];

    [self initPageControl_qianggou];
    
}
- (void)addTagArray:(NSMutableArray *)tag
{
    tagArray = [NSMutableArray array];
    tagArray = tag;
}

#pragma mark
- (void)timeDuanMethod:(UIButton *)btn
{
    if (tagArray.count != 0) {
        
    NSInteger current_tag = btn.tag-QIANGGOU_TAG;
    NSInteger count = [[tagArray objectAtIndex:current_tag] integerValue];
    for (int i = 0; i<3; i++) {
        UIButton *button2 = (UIButton *)[self viewWithTag:QIANGGOU_TAG+i];
        button2.selected = NO;
//        [btn setEnabled:YES];
    }
    btn.selected  = YES;
    NSInteger currenPage = 0;
    switch (current_tag) {
        case 0:
        {
            currenPage = 0;
        }
            break;
        case 1:
        {
//            NSInteger count1 = [[tagArray objectAtIndex:1] integerValue];
            currenPage = count;
        }
        break;
        case 2:
        {
            NSInteger count2 = [[tagArray objectAtIndex:0] integerValue];
            NSInteger count3 = [[tagArray objectAtIndex:1] integerValue];
            currenPage = count3+count2;
        }
        break;
    }
    [qianggouScrollView scrollRectToVisible:CGRectMake(currenPage * SCREEN_WIDTH, 65.0, SCREEN_WIDTH, SCREEN_HEIGHT/3) animated:YES];
    }   
}


@end
