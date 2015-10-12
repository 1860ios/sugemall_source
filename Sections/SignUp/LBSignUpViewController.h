//
//  LBSignUpViewController.h
//  SuGeMarket
//
//  注册
//  Created by 1860 on 15/4/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBSignUpViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *tt;
    UIButton *cancel;
    UIButton *getVcode;
    
}
@property (nonatomic, retain) UIView *navView;
@property (nonatomic, retain) UIButton *signUp;
@end
