//
//  LBArticleCell.m
//  SuGeMarket
//
//  Created by Apple on 15/10/28.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBArticleCell.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>

@interface LBArticleCell (){
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    UIImageView *_picImage;
    UILabel *_readLabel;
}
@end

@implementation LBArticleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadArticleCell];
    }
    return self;
}

- (void)loadArticleCell
{
    UIView *cellBackGroudView =[[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 400)];
    cellBackGroudView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cellBackGroudView.layer.borderWidth = 0.5;
    cellBackGroudView.layer.cornerRadius = 7;
    cellBackGroudView.layer.masksToBounds = YES;
    cellBackGroudView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cellBackGroudView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-30, 30)];
    _titleLabel.font = FONT(22);
    [cellBackGroudView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, _titleLabel.frame.size.width, 20)];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = FONT(16);
    [cellBackGroudView addSubview:_timeLabel];
    
    _picImage = [[UIImageView alloc] initWithFrame:CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y+_timeLabel.frame.size.height+5, _timeLabel.frame.size.width, 200)];
    [cellBackGroudView addSubview:_picImage];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picImage.frame.origin.x, _picImage.frame.origin.y+_picImage.frame.size.height,_picImage.frame.size.width, 100)];
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font = FONT(18);
    _contentLabel.numberOfLines = 0;
    [cellBackGroudView addSubview:_contentLabel];
    
    _readLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y+_contentLabel.frame.size.height+10, 100, 30)];
    _readLabel.font = FONT(20);
    _readLabel.text = @"阅读全文";
    [cellBackGroudView addSubview:_readLabel];
    UIImageView *jiantouImage = [[UIImageView alloc] initWithFrame:CGRectMake(cellBackGroudView.frame.size.width-5-30, _readLabel.frame.origin.y, 30, 30)];
    jiantouImage.image = IMAGE(@"财富_07");
    [cellBackGroudView addSubview:jiantouImage];
}

- (void)addValueForArticleCell:(NSDictionary *)value
{
    _titleLabel.text =value[@"article_title"];
    _timeLabel.text = value[@"article_time"];
    _contentLabel.text = value[@"article_content"];
    [_picImage sd_setImageWithURL:[NSURL URLWithString:value[@"article_cover"]] placeholderImage:IMAGE(SUGE_PIC)];
}

@end
