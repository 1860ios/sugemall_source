//
//  LBLognInViewController.h
//  SuGeMarket
//
//  登陆
//  Created by 1860 on 15/4/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFViewShaker.h"
#import "UtilsMacro.h"
#import <AFNetworking.h>
#import "LBSignUpViewController.h"
#import "LBUserInfo.h"


@interface LBLognInViewController : UIViewController<UITextFieldDelegate>
{
    AFViewShaker *shaker;
}
@property (nonatomic, retain) UITextField *nameCount;
@property (nonatomic, retain) UITextField *pwd;
@property (nonatomic, retain) UIButton *lognIn;
@property (nonatomic, retain) UIButton *signUp;
@property (nonatomic, retain) UIButton *showPSW;

@end
