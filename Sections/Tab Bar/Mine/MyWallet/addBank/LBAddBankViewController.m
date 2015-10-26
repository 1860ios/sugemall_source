//
//  LBAddBankViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/14.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBAddBankViewController.h"
#import "SUGE_API.h"
#import "UtilsMacro.h"
static NSString *cid=@"cid";
@interface LBAddBankViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSInteger tag;
    UITextField *_cardTextField,*_peopleTextField,*_typeTextField,*_codeTextField;
    UIButton *bindingButton;
}
@property(nonatomic,strong)UITableView *addTableView;
@end

@implementation LBAddBankViewController
@synthesize addTableView;
- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [super viewDidLoad];
    [self initTableView];
}
#pragma mark 初始化tableview
-(void)initTableView
{
    tag=4;
    addTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStylePlain];
    addTableView.delegate=self;
    addTableView.dataSource=self;
//    [addTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    addTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    addTableView.separatorColor = [UIColor redColor];
    addTableView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self.view addSubview:addTableView];
    
    bindingButton=[UIButton buttonWithType:UIButtonTypeCustom];
   bindingButton.frame=CGRectMake(10,44*6+40+120,SCREEN_WIDTH-20,40);
    [bindingButton setTitle:@"绑定" forState:0];
    [bindingButton setTitleColor:[UIColor whiteColor] forState:0];
    [bindingButton addTarget:self action:@selector(clickBinding) forControlEvents:UIControlEventTouchUpInside];
    bindingButton.backgroundColor=[UIColor grayColor];
    bindingButton.layer.cornerRadius=10;
    [self.view addSubview:bindingButton];
}
#pragma mark tableview  delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *tixingLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    if (section==1) {
        tixingLabel.text=@"请输入完整的支付宝账户,以免打款失败";
        tixingLabel.text=@"请绑定持卡人的银行卡,以免打款失败";
        tixingLabel.font=FONT(18);
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
    UIImageView *bankImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40,44)];
    
    UIButton *bankButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bankButton.frame=CGRectMake(bankImageView.frame.origin.x+bankImageView.frame.size.width+10, bankImageView.frame.origin.y,SCREEN_WIDTH-bankImageView.frame.origin.x-bankImageView.frame.size.width-10-40, 44);
    [bankButton setTitleColor:[UIColor blackColor] forState:0];
    bankButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bankButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [bankButton addTarget:self action:@selector(binding:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, bankButton.frame.origin.y+bankButton.frame.size.height, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    
    UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40,bankButton.frame.origin.y, 40, 44)];
    rightImageView.image=IMAGE(@"");
    [cell.contentView addSubview:rightImageView];
    
    if (indexPath.section==0&&indexPath.row==0) {
        bankImageView.image=IMAGE(@"");
        [cell.contentView addSubview:bankImageView];

        [bankButton setTitle:@"绑定银行卡" forState:0];
        bankButton.tag=100;
        [cell.contentView addSubview:bankButton];
        
        [cell.contentView addSubview:lineView];

    }else if(indexPath.section==0&&indexPath.row==1)
    {
        bankImageView.image=IMAGE(@"");
        [cell.contentView addSubview:bankImageView];
        [bankButton setTitle:@"绑定支付宝" forState:0];
        bankButton.tag=101;
        [cell.contentView addSubview:bankButton];
    }
    else if(indexPath.section==1)
    {
        NSArray *cardArray=@[@"银行卡号",@"持卡人",@"发卡银行",@"验证码"];
        UILabel *cardLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
            cardLabel.text=cardArray[indexPath.row];
            cardLabel.textAlignment=NSTextAlignmentLeft;
            cardLabel.textColor=[UIColor blackColor];
            cardLabel.font=FONT(18);
            [cell.contentView addSubview:cardLabel];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(cardLabel.frame.origin.x+cardLabel.frame.size.width+10, 44, SCREEN_WIDTH, 1)];
        lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
        
        UIButton *gainButton=[UIButton buttonWithType:UIButtonTypeCustom];

        switch (indexPath.row) {
            case 0:
                _cardTextField=[[UITextField alloc]initWithFrame:CGRectMake(cardLabel.frame.origin.x+cardLabel.frame.size.width+10, cardLabel.frame.origin.y, SCREEN_WIDTH-cardLabel.frame.origin.x-cardLabel.frame.size.width, 44)];
                _cardTextField.delegate =self;
                _cardTextField.font = [UIFont systemFontOfSize:15];
                _cardTextField.textColor = [UIColor blackColor];
                _cardTextField.keyboardType = UIKeyboardTypePhonePad;
                _cardTextField.textAlignment = NSTextAlignmentLeft;
                _cardTextField.placeholder=@"输入银行卡号";
                _cardTextField.borderStyle = UITextBorderStyleNone;
                _cardTextField.clearButtonMode = UITextFieldViewModeAlways;
                [cell.contentView addSubview:_cardTextField];
                [cell.contentView addSubview:lineView];
                break;
            case 1:
                _peopleTextField = [[UITextField alloc] initWithFrame:CGRectMake(_cardTextField.frame.origin.x,0, _cardTextField.frame.size.width, 44)];
                _peopleTextField.delegate = self;
                _peopleTextField.tag = TEXTFEILD_TAG+10;
                _peopleTextField.font = [UIFont systemFontOfSize:15];
                _peopleTextField.borderStyle = UITextBorderStyleNone;
                _peopleTextField.placeholder = @"输入持卡人姓名";
                _peopleTextField.clearButtonMode = UITextFieldViewModeAlways;
                [cell.contentView addSubview:_peopleTextField];
                [cell.contentView addSubview:lineView];
 
                break;
            case 2:
                _typeTextField = [[UITextField alloc] initWithFrame:CGRectMake(_peopleTextField.frame.origin.x,0, _peopleTextField.frame.size.width, 44)];
                _typeTextField.delegate = self;
                _typeTextField.tag = TEXTFEILD_TAG+11;
                _typeTextField.borderStyle = UITextBorderStyleNone;
                _typeTextField.font = [UIFont systemFontOfSize:15];
                _typeTextField.placeholder = @"输入发卡银行";
                _typeTextField.clearButtonMode = UITextFieldViewModeAlways;
                [cell.contentView addSubview:_typeTextField];
                [cell.contentView addSubview:lineView];

                break;
            case 3:
                _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(_typeTextField.frame.origin.x,0, _typeTextField.frame.size.width-100, 44)];
                _codeTextField.delegate = self;
                _codeTextField.tag = TEXTFEILD_TAG+12;
                _codeTextField.borderStyle = UITextBorderStyleNone;
                _codeTextField.font = [UIFont systemFontOfSize:15];
                _codeTextField.keyboardType = UIKeyboardTypePhonePad;
                _codeTextField.clearButtonMode = UITextFieldViewModeAlways;
                _codeTextField.placeholder = @"输入验证码";
                [cell.contentView addSubview:_codeTextField];
                
                gainButton.frame=CGRectMake(_codeTextField.frame.origin.x+_codeTextField.frame.size.width,_codeTextField.frame.origin.y+5,80,_codeTextField.frame.size.height-10);
                [gainButton setTitle:@"获取" forState:0];
                gainButton.layer.cornerRadius=10;
                [gainButton setTitleColor:[UIColor lightGrayColor] forState:0];
                [gainButton addTarget:self action:@selector(gain) forControlEvents:UIControlEventTouchUpInside];
                gainButton.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
                [cell.contentView addSubview:gainButton];

                break;
            default:
                break;
        }
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
        return tag;
}
-(void)binding:(UIButton *)btn
{
    if (btn.tag==100) {
        tag=4;
    }else if(btn.tag==101)
    {
        tag=3;
    }
    [addTableView reloadData];
}
-(void)gain
{
}
-(void)clickBinding
{
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_cardTextField.text.length!=0&&_peopleTextField.text.length!=0&&_typeTextField.text.length!=0) {
        bindingButton.backgroundColor=[UIColor redColor];
    }else{
    bindingButton.backgroundColor=[UIColor grayColor];
    }
}
@end
