//
//  LBGroupBuyStoreCell.m
//  SuGeMarket
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBGroupBuyStoreCell.h"
#import "UtilsMacro.h"
#import "AppMacro.h"
#import <UIImageView+WebCache.h>

@interface LBGroupBuyStoreCell ()
{
    UIImageView *_stroe_image;
    UILabel *_store_namel_label;
    
    UILabel *_store_salecount_label;
    UILabel *_store_collectcount_label;
    
    //
    UIButton *all_goods_button;
    UIButton *go_store_button;
}

@end

@implementation LBGroupBuyStoreCell
@synthesize go_store_button;
@synthesize all_goods_button;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self loadGroupBuyStoreCell];
    }
    return self;
}

- (void)loadGroupBuyStoreCell
{
    _stroe_image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
    [self addSubview:_stroe_image];
    
    _store_namel_label = [[UILabel alloc] initWithFrame:CGRectMake(_stroe_image.frame.origin.x+_stroe_image.frame.size.width+10, _stroe_image.frame.origin.y, 200, 20)];
    _store_namel_label.font = FONT(19);
    [self addSubview:_store_namel_label];

    _store_salecount_label = [[UILabel alloc] initWithFrame:CGRectMake(_store_namel_label.frame.origin.x, _store_namel_label.frame.origin.y+_store_namel_label.frame.size.height+5, 100, 15)];
    _store_salecount_label.font = FONT(16);
    _store_salecount_label.textColor = [UIColor lightGrayColor];
    [self addSubview:_store_salecount_label];

    _store_collectcount_label = [[UILabel alloc] initWithFrame:CGRectMake(_store_salecount_label.frame.origin.x+_store_salecount_label.frame.size.width, _store_salecount_label.frame.origin.y, 100, 15)];
    _store_collectcount_label.font = FONT(16);
    _store_collectcount_label.textColor = [UIColor lightGrayColor];
    [self addSubview:_store_collectcount_label];

    for (int i = 0; i<3; i++) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0+i*(SCREEN_WIDTH/3), _stroe_image.frame.origin.y+_stroe_image.frame.size.height+10, SCREEN_WIDTH/3, 40)];
        view1.backgroundColor = [UIColor whiteColor];
        [self addSubview:view1];

        UILabel *store_text1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 30)];
        store_text1.font = FONT(14);
        store_text1.tag = 120+i;
        [view1 addSubview:store_text1];
        
        UILabel *store_credit1 = [[UILabel alloc] initWithFrame:CGRectMake(store_text1.frame.origin.x+store_text1.frame.size.width, 5, 20, 30)];
        store_credit1.textColor = APP_COLOR;
        store_credit1.font = FONT(13);
        store_credit1.tag = 220+i;
        [view1 addSubview:store_credit1];
        
        UILabel *store_percent_text1 = [[UILabel alloc] initWithFrame:CGRectMake(store_credit1.frame.origin.x+store_credit1.frame.size.width, 10, 25, 15)];
        store_percent_text1.font = FONT(11);
        store_percent_text1.tag = 320+i;
        store_percent_text1.backgroundColor = APP_COLOR;
        store_percent_text1.textColor = [UIColor whiteColor];
        [view1 addSubview:store_percent_text1];


    }
    UIView *line_view1 = [[UIView alloc] initWithFrame:CGRectMake(15, _stroe_image.frame.origin.y+_stroe_image.frame.size.height+10+20+10+20, SCREEN_WIDTH-30, 1)];
    line_view1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line_view1];
    
    all_goods_button = [UIButton buttonWithType:UIButtonTypeCustom];
    all_goods_button.frame = CGRectMake(30, line_view1.frame.origin.y+line_view1.frame.size.height+15, 120, 40);
    all_goods_button.backgroundColor = [UIColor whiteColor];
    [all_goods_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    all_goods_button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    all_goods_button.layer.borderWidth = 1;
    [all_goods_button setTitle:@"全部商品" forState:UIControlStateNormal];
    [self addSubview:all_goods_button];
    
    go_store_button = [UIButton buttonWithType:UIButtonTypeCustom];
    go_store_button.frame = CGRectMake(SCREEN_WIDTH-30-120, all_goods_button.frame.origin.y, 120, 40);
    go_store_button.backgroundColor = [UIColor whiteColor];
    [go_store_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    go_store_button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    go_store_button.layer.borderWidth = 1;
    [go_store_button setTitle:@"进入店铺" forState:UIControlStateNormal];
    [self addSubview:go_store_button];
    
    UIView *lin1 = [[UIView alloc] initWithFrame:CGRectMake(0, all_goods_button.frame.origin.y+all_goods_button.frame.size.height+45, (SCREEN_WIDTH/2)-60, 1)];
    lin1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lin1];
    UILabel *guangLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, lin1.frame.origin.y-10, 120, 20)];
    guangLabel.text = @"上拉进入图文详情";
    guangLabel.font = FONT(15);
    guangLabel.textColor = [UIColor lightGrayColor];
    guangLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:guangLabel];
    UIView *lin2 = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2)+60, lin1.frame.origin.y, SCREEN_WIDTH/2-60, 1)];
    lin2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lin2];
}

- (void)addValueForGroupBuyStoreCell:(NSDictionary *)value
{
    [_stroe_image sd_setImageWithURL:[NSURL URLWithString:value[@"store_avatar"]] placeholderImage:IMAGE(SUGE_PIC)];
    _store_namel_label.text = value[@"store_name"];
    _store_salecount_label.text = [NSString stringWithFormat:@"总销量:%@",value[@"store_sales"]];
    _store_collectcount_label.text = [NSString stringWithFormat:@"收藏数:%@",value[@"store_collect"]];
    NSString *goods_count = value[@"goods_count"];
    [all_goods_button setTitle:[NSString stringWithFormat:@"全部商品(%@)",goods_count] forState:UIControlStateNormal];
    NSArray *type_store_credit_array = @[@"store_deliverycredit",@"store_desccredit",@"store_servicecredit"];

    for (int i = 0; i<3; i++) {
        UILabel *store_text1 = (UILabel *)[self viewWithTag:120+i];
        UILabel *store_credit1 = (UILabel *)[self viewWithTag:220+i];
        UILabel *store_percent_text1 = (UILabel *)[self viewWithTag:320+i];
        NSString *type_store_credit = type_store_credit_array[i];
        store_text1.text =value[@"store_credit"][type_store_credit][@"text"];
        float credit = [value[@"store_credit"][type_store_credit][@"credit"] floatValue];
        store_credit1.text = [NSString stringWithFormat:@"%0.1f",credit];
        store_percent_text1.text =value[@"store_credit"][type_store_credit][@"percent_text"];
    }

}

@end
