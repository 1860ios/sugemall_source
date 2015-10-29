//
//  LBOrderMessageCell.m
//  SuGeMarket
//
//  Created by Apple on 15/10/28.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBOrderMessageCell.h"
#import "UtilsMacro.h"
#import "AppMacro.h"
#import <UIImageView+WebCache.h>

@interface LBOrderMessageCell ()
{
    UILabel *_time_label;
    UILabel *_title_label;
    UIImageView *_gc_image;
    UILabel *_gc_name_label;
    UILabel *_content_label;
    UILabel *readLabel;
    
}
@end

@implementation LBOrderMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)Style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadOrderMessageCell];
    }
    return self;
}

- (void)loadOrderMessageCell
{
    _time_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 5, 200, 20)];
    _time_label.textAlignment = NSTextAlignmentCenter;
    _time_label.textColor = [UIColor lightGrayColor];
    [self addSubview:_time_label];
    
    UIView *orderMessageBG = [[UIView alloc] initWithFrame:CGRectMake(15, _time_label.frame.origin.y+_time_label.frame.size.height, SCREEN_WIDTH-30, 400)];
    orderMessageBG.backgroundColor = [UIColor whiteColor];
    [self addSubview:orderMessageBG];
    
    float _width = orderMessageBG.frame.size.width;
    
    UIView *lin1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 3)];
    lin1.backgroundColor = APP_COLOR;
    [orderMessageBG addSubview:lin1];

    
    _title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, _width-20, 30)];
    _title_label.font = FONT(20);
    [orderMessageBG addSubview:_title_label];
    
    _gc_image = [[UIImageView alloc] initWithFrame:CGRectMake(_title_label.frame.origin.x, _title_label.frame.origin.y+_title_label.frame.size.height+5, 160, 160)];
    [orderMessageBG addSubview:_gc_image];
    
    _gc_name_label = [[UILabel alloc] initWithFrame:CGRectMake(_gc_image.frame.origin.x+_gc_image.frame.size.width+10, _gc_image.frame.origin.y+3, _width-160-10-10-10, 160-6)];
    _gc_name_label.font = FONT(16);
    _gc_name_label.numberOfLines = 0;
    [orderMessageBG addSubview:_gc_name_label];
    
    _content_label = [[UILabel alloc] initWithFrame:CGRectMake(_gc_image.frame.origin.x, _gc_image.frame.origin.y+_gc_image.frame.size.height+10, _width-20, 100)];
    _content_label.font = FONT(16);
    _content_label.numberOfLines = 0;
    [orderMessageBG addSubview:_content_label];
    
    UIView *lin2 = [[UIView alloc] initWithFrame:CGRectMake(3, _content_label.frame.origin.y+_content_label.frame.size.height+5, _width-6, 1)];
    lin2.backgroundColor = [UIColor lightGrayColor];
    [orderMessageBG addSubview:lin2];
    
    readLabel = [[UILabel alloc] initWithFrame:CGRectMake(_content_label.frame.origin.x, lin2.frame.origin.y+lin2.frame.size.height+10, 100, 20)];
    readLabel.font = FONT(19);
    readLabel.text = @"查看详情";
    [orderMessageBG addSubview:readLabel];
    
    UIImageView *jiantouImage = [[UIImageView alloc] initWithFrame:CGRectMake(_width-5-30, readLabel.frame.origin.y, 30, 30)];
    jiantouImage.image = IMAGE(@"财富_07");
    [orderMessageBG addSubview:jiantouImage];
    
}

- (void)addValueForOrderMessageCell:(NSDictionary *)value
{
    _time_label.text = value[@"push_time"];
    _title_label.text = value[@"push_title"];
    [_gc_image sd_setImageWithURL:[NSURL URLWithString:value[@"img_url"]] placeholderImage:IMAGE(SUGE_PIC)];
    _gc_name_label.text = value[@"img_desc"];
    _content_label.text = value[@"push_content"];
}

@end
