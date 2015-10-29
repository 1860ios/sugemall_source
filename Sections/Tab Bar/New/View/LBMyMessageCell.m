//
//  LBMyMessageCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/8/13.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMyMessageCell.h"
#import "UtilsMacro.h"
@interface LBMyMessageCell (){
    UIImageView *iconView;
    UILabel *titleLabel;
    UILabel *title;
    UILabel *timeLabel;
    UILabel *time;
    UILabel *content;
}
@end

@implementation LBMyMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)Style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView1];
    }
    return self;
}

- (void)initView1
{
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.image = IMAGE(@"suge_icon");
    [self.contentView addSubview:iconView];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width+10, iconView.frame.origin.y, 40, 30)];
    titleLabel.text = @"标题:";
    [self addSubview:titleLabel];
    title = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width, titleLabel.frame.origin.y, SCREEN_WIDTH-titleLabel.frame.origin.x-titleLabel.frame.size.width-10, 30)];
        title.font = FONT(18);
    [self addSubview:title];
    //加入时间
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height, 40, 30)];
    timeLabel.text = @"时间:";
    [self addSubview:timeLabel];
    time = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x+timeLabel.frame.size.width, timeLabel.frame.origin.y, 200, 30)];

    [self addSubview:time];
    content = [[UILabel alloc] initWithFrame:CGRectMake(10,80,SCREEN_WIDTH-20,40)];
    [self addSubview:content];
}
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    content.text = text;
    //设置label的最大行数
    content.numberOfLines = 0;
    CGSize size = CGSizeMake(300, 1000);
    CGSize labelSize = [content.text sizeWithFont:content.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
//    CGSize labelSize = [self.content.text boundingRectWithSize:size options:<#(NSStringDrawingOptions)#> attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>];
    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, labelSize.width, labelSize.height);
    
    //计算出自适应的高度
    frame.size.height = labelSize.height+100;
    
    self.frame = frame;
}
- (void)addValueForMessageCell:(NSDictionary *)value
{
    title.text = value[@"push_title"];
    time.text = value[@"push_time"];
    [self setIntroductionText:value[@"push_content"]];
}

@end
