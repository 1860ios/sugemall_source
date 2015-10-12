//
//  YBUserInfo.h
//  SuGeMarket
//
//  Created by 1860 on 15/4/23.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LBMemberInfo.h"

@interface LBUserInfo : NSObject

@property (nonatomic,copy) NSString *avatar;//用户头像
@property (nonatomic,copy) NSString *isVip;//isVip
@property (nonatomic,copy) NSString *userinfo_username;//用户名
@property (nonatomic,copy) NSString *userinfo_pwd;//用户密码
@property (nonatomic,copy) NSString *userinfo_key;//token

//@property (nonatomic,strong) LBMemberInfo *memberInfo;

+ (LBUserInfo *)sharedUserSingleton;
//保存用户的登陆信息
-(void)saveLoginInfo:(NSDictionary *)info;
//删除用户的登陆信息
-(void)deleteAccountInfo;
//返回用户的登录状态
-(BOOL)isLogin;
@end
