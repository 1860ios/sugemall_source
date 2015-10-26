//
//  LBArticlesViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/21.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBArticlesViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "SVProgressHUD.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
@interface LBArticlesViewController ()
{
    NSDictionary *contentDictionary;
    NSString *htmlString;
    UILabel *textView;
}
@end

@implementation LBArticlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
}
-(void)loadDatas
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"article_id":_article_id};

    [manager POST:SUGE_TEXT parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"datas"]);
        if (![responseObject[@"datas"] isKindOfClass:[NSString class]]) {
                contentDictionary=responseObject[@"datas"][@"article_detail"];
        }
        NSString *setWidthString = [NSString stringWithFormat:@"<style>img{width:%fpx !important;}</style>",SCREEN_WIDTH];
        //    NSString *htmlStr = @"【产品名称】：韩国伊思蜗牛乳（清爽型）140ml<br />\r\n【产品价格】：245元<br />\r\n【产品产地】：韩国<br />\r\n<p>\r\n\t【产品攻效】： 淡化疤痕、祛暗疮痘印、斑点，祛除暗黄，恢复正常肤色， 紧致毛孔，修护敏感肌肤、红血丝等受损肌肤。\r\n</p>\r\n<p>\r\n\t【产品介绍】：内含螺旋蜗牛分泌液29400MG（浓度21%）能够全面改善修复皮肤，一起对淡化痘印，淡化瘢痕，暗疮印记，去暗黄，收缩紧致毛孔有非常神奇的功效，是是全世界皮肤医师推荐使用的护肤保养品。使用后，肌肤能明显变得柔嫩紧实，细腻白皙，细纹减少，较深的皱纹与粗大的毛孔也能轻易获得改善，甚至最干燥及过敏性肌肤也能恢复到健康自然的状态。\r\n</p>\r\n<p>\r\n\t【适合肌肤】：油性，混合性，尤其适合痘痘肌。\r\n</p>\r\n【使用说明】：于爽肤水后，取适量产品，均匀涂抹于整个面部，轻轻拍打直至吸收。<br />\r\n<p>\r\n\t<img src=\"http://wifi.i7i5.com/Uploads/2015-07-13/55a3672d57cd7.jpg\" alt=\"\" />\r\n</p>\r\n<div>\r\n\t<br />\r\n</div>";
        NSString *htmlStr=contentDictionary[@"article_content"];
        htmlString = [NSString stringWithFormat:@"%@%@",setWidthString,htmlStr];
        [self initView];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [SVProgressHUD dismiss];
}
-(void)initView
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:17]} documentAttributes:nil error:nil];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(SCREEN_WIDTH, FLT_MAX)];
    [textContainer setLineFragmentPadding:0.0];
    [layoutManager addTextContainer:textContainer];
    [textStorage setAttributedString:attributedString];
    [layoutManager ensureLayoutForTextContainer:textContainer];
    CGRect frame = [layoutManager usedRectForTextContainer:textContainer];
    
    CGFloat htmlHeight = CGRectGetHeight(frame);
    NSLog(@"%f",htmlHeight);
    
    textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,htmlHeight)];
    //
    //    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    textView.attributedText = attributedString;
    textView.numberOfLines = 0;
    [self.view addSubview:textView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDatas];
}

@end
