//
//  LBSelecGoodsView.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBSelecGoodsView.h"
#import "UIView+Extension.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>


@interface LBSelecGoodsView()
{
    UIButton *_button;

}

@end

@implementation LBSelecGoodsView
@synthesize radiobox1,radiobox2,radioGroup1,radioGroup2;


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubViews];
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)addSubViews
{
    __goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 70, 70)];
    __goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:__goodsImage];
    
    __goodsPrice =[[UILabel alloc] initWithFrame:CGRectMake(__goodsImage.frame.origin.x+__goodsImage.frame.size.width+10, __goodsImage.frame.origin.y, 100, 25)];
    __goodsPrice.textColor = APP_COLOR;
    [self addSubview:__goodsPrice];
    
    __goodsStorge = [[UILabel alloc] initWithFrame:CGRectMake(__goodsPrice.frame.origin.x, __goodsPrice.frame.origin.y+__goodsPrice.frame.size.height, 120, 25)];
    __goodsStorge.textColor = [UIColor blackColor];
    __goodsStorge.adjustsFontSizeToFitWidth = YES;
    [self addSubview:__goodsStorge];
    
    __sepecName = [[UILabel alloc] initWithFrame:CGRectMake(__goodsStorge.frame.origin.x, __goodsStorge.frame.origin.y+__goodsStorge.frame.size.height, 80, 35)];
    __sepecName.textColor = [UIColor blackColor];
    __sepecName.text = @"请选择";
    __sepecName.adjustsFontSizeToFitWidth = YES;
    [self addSubview:__sepecName];

//    UIView *lineView= [[UIView alloc] initWithFrame:CGRectMake(__goodsImage.frame.origin.x, __goodsImage.frame.origin.x+__goodsImage.frame.size.height+30, self.frame.size.width-2*(__goodsImage.frame.origin.x), 1)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:lineView];
    
    //1111
    __specNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(__goodsImage.frame.origin.x, __goodsImage.frame.origin.y+__goodsImage.frame.size.height, 80, 35)];
    __specNameLabel.textColor = [UIColor blackColor];
    __specNameLabel.text = @"颜色分类";
    [self addSubview:__specNameLabel];

    
    //2222
    __sepecName = [[UILabel alloc] initWithFrame:CGRectMake(__specNameLabel.frame.origin.x+__specNameLabel.frame.size.width+45, __specNameLabel.frame.origin.y, 40, 35)];
    __sepecName.textColor = [UIColor blackColor];
    __sepecName.text = @"尺码";
    __sepecName.adjustsFontSizeToFitWidth = YES;
    [self addSubview:__sepecName];

    
    
    _addCarBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    _addCarBTN.frame = CGRectMake(20,self.frame.size.height-EACH_H-9,self.frame.size.width/2-20-5,35);
//    [_addCarBTN setBackgroundColor:APP_BOTTOM_BAR_ADD_CAR];
    _addCarBTN.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _addCarBTN.layer.borderWidth = 1.0f;
    [_addCarBTN setTitle:@"加入购物车" forState:0];
    [_addCarBTN setTitleColor:[UIColor blackColor] forState:0];
    _addCarBTN.titleLabel.font = FONT(15);
    [self addSubview:_addCarBTN];
    

    _BuyNowBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    _BuyNowBTN.frame = CGRectMake(_addCarBTN.frame.origin.x+_addCarBTN.frame.size.width+10,_addCarBTN.frame.origin.y,_addCarBTN.frame.size.width,_addCarBTN.frame.size.height);
//    [_BuyNowBTN setBackgroundColor:APP_BOTTOM_BAR_BUY_NOW];
    _BuyNowBTN.layer.borderColor = [APP_COLOR CGColor];
    _BuyNowBTN.layer.borderWidth = 1.0f;
    [_BuyNowBTN setTitle:@"立即购买" forState:0];
    _BuyNowBTN.titleLabel.font = FONT(15);
    [_BuyNowBTN setTitleColor:[UIColor blackColor] forState:0];
    [self addSubview:_BuyNowBTN];
    
    _numButton = [[HJCAjustNumButton alloc] init];
    _numButton.frame = CGRectMake(self.frame.size.width/2-60,_addCarBTN.frame.origin.y-40,120,30);
//    _numButton.callBack = ^(NSString *curNum){
//        NSLog(@"curNum:%@",curNum);
//        currentNum = curNum;
//        
//    };
    [self addSubview:_numButton];
}

- (void)addValue:(LBGoodsDetailModel *)model
{
//#warning 调整接口spec 图片带数字
    [__goodsImage sd_setImageWithURL:[NSURL URLWithString:[model.spec_image allValues][0]] placeholderImage:IMAGE(@"dd_03_@2x")];
    __goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.goods_info.goods_price];
    __goodsStorge.text = [NSString stringWithFormat:@"库存%@件",model.goods_info.goods_storage];

    if ([model.goods_info.spec_name isEqual:[NSNull null]] ) {
        __specNameLabel.text = @"";
        __sepecName.text = @"";
    }else if ([model.goods_info.spec_value isEqual:[NSNull null]]){
        
    }else {
        for (int i = 0; i<[[model.goods_info.spec_name allValues] count]; i++) {
            if (i == 0) {
                __specNameLabel.text = [model.goods_info.spec_name allValues][i];
            }else if (i == 1){
            __sepecName.text =[model.goods_info.spec_name allValues][i];
            }

        }
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_numButton._textField resignFirstResponder];
}
@end

