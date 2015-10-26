//
//  LBInviteViewController.m
//  SuGeMarket
//
//  邀请合伙人
//  Created by Apple on 15/10/18.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBInviteViewController.h"
#import "UtilsMacro.h"
#import "LBMyQRCodeViewController.h"
#import "SUGE_API.h"
#import <TSMessage.h>
#import "UMSocial.h"
#import "LBUserInfo.h"
static NSString *cid=@"cid";
@interface LBInviteViewController()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong)UITableView *_tableView;
@end
@implementation LBInviteViewController
@synthesize _tableView;
-(void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithWhite:0.95 alpha:0.93];
    self.title=@"邀请合伙人";
    _tableView=({
        UITableView *tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 251) style:UITableViewStylePlain];
        tableView.delegate =self;
        tableView.dataSource = self;
        tableView.backgroundColor=[UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView;
    });
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [self initButton];
}
#pragma mark tableview  delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *tixingLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    if (section==1) {
        tixingLabel.text=@"合伙人";
        tixingLabel.font=FONT(15);
        tixingLabel.textAlignment=NSTextAlignmentLeft;
        tixingLabel.textColor=[UIColor grayColor];
        tixingLabel.backgroundColor=[UIColor clearColor];
    }
    return tixingLabel;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 80, 80)];
    
    UILabel *inviteLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width,imageView.frame.origin.y+20, 200, 20)];
    inviteLabel.textAlignment=NSTextAlignmentLeft;
    inviteLabel.textColor=[UIColor blackColor];
    inviteLabel.font=FONT(13);

    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(inviteLabel.frame.origin.x, inviteLabel.frame.origin.y+inviteLabel.frame.size.height, SCREEN_WIDTH-imageView.frame.origin.x-imageView.frame.size.width-10, 80-35)];
    contentLabel.textAlignment=NSTextAlignmentLeft;
    contentLabel.textColor=[UIColor lightGrayColor];
    contentLabel.font=FONT(12);

    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y+contentLabel.frame.size.height+10, contentLabel.frame.size.width+10, 1)];
    lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, contentLabel.frame.origin.y+contentLabel.frame.size.height+10, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];

    if (indexPath.row==0) {
        imageView.image=IMAGE(@"myrefrere_Icon");
        [cell.contentView addSubview:imageView];

        inviteLabel.text=@"直接邀请";
        [cell.contentView addSubview:inviteLabel];
        
        contentLabel.text=@"分享到微信、QQ等渠道,好友点击注册并下载登陆,即可成为合伙人";
        contentLabel.numberOfLines = 2;
        [cell.contentView addSubview:contentLabel];
        [cell.contentView addSubview:lineView];
    }else{
        imageView.image=IMAGE(@"myrefrere_Icon");
        [cell.contentView addSubview:imageView];
        
        inviteLabel.text=@"二维码邀请";
        [cell.contentView addSubview:inviteLabel];
        
        contentLabel.text=@"分享到微信、QQ等渠道,好友扫一扫或长按识别二维码后注册并下载登陆,即可成为合伙人";
        contentLabel.numberOfLines = 3;
        [cell.contentView addSubview:contentLabel];
        [cell.contentView addSubview:lineView1];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSString *QRCodeStr = [NSString stringWithFormat:@"%@%@",SUGE_QRCODEURL,key];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = QRCodeStr;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = QRCodeStr;

    LBMyQRCodeViewController *myQRCode=[[LBMyQRCodeViewController alloc]init];
    if (indexPath.row==0) {
        
    }else{
        [UMSocialSnsService presentSnsController:self appKey:nil shareText:@"分享的内容" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,nil] delegate:nil];

        [self.navigationController pushViewController:myQRCode animated:YES];
    }
}
-(void)initButton
{
    UIButton *mineButton=[UIButton buttonWithType:UIButtonTypeCustom];
    mineButton.frame=CGRectMake(SCREEN_WIDTH/2-50,SCREEN_HEIGHT-80-20,75, 20);
    [mineButton setTitleColor:[UIColor orangeColor] forState:0];
    mineButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [mineButton setTitle:@"合伙人规则" forState:0];
    [self.view addSubview:mineButton];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(mineButton.frame.origin.x, mineButton.frame.origin.y+mineButton.frame.size.height, mineButton.frame.size.width, 1)];
    lineView1.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:lineView1];

}
@end
