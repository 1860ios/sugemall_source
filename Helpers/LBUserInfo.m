//
//  YBUserInfo.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/23.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBUserInfo.h"
#import "AppMacro.h"

@implementation LBUserInfo

static LBUserInfo *userInfo;
+ (id) allocWithZone:(struct _NSZone *)zone
{
    
    static LBUserInfo *userInfo;//静态指针，
    static dispatch_once_t once ;
    
    dispatch_once(&once, ^{
        userInfo = [super allocWithZone:zone];
    });
    
    return userInfo;
}

+ (LBUserInfo *)sharedUserSingleton
{
    if (!userInfo) {
        userInfo = [[LBUserInfo alloc]init];
    }
    return userInfo;
}

- (id)init
{
    self = [super init];
    if (self) {
        _userinfo_username = [USER_DEFAULT objectForKey: suge_username];
        _userinfo_pwd = [USER_DEFAULT objectForKey: suge_pwd];
        _userinfo_key = [USER_DEFAULT objectForKey: suge_key];
        _isVip = [USER_DEFAULT objectForKey: suge_isVip];
        _avatar = [USER_DEFAULT objectForKey: suge_avatar];
    }
    return self;
}


-(void)saveLoginInfo:(NSDictionary *)info
{
    if ([info[suge_username] isEqual:[NSNull null]]) {
        _userinfo_username = @"suge";
    }else{
    _userinfo_username = info[suge_username];
    }
    if ( [info[suge_avatar] isEqual:[NSNull null]] ) {
        _avatar = @"https://sugemall.com/mobile/images/defaulthead.jpg";
    }else{
        _avatar = info[suge_avatar];
    }
    _userinfo_pwd = info[suge_pwd];
    _userinfo_key = info[suge_key];
    _isVip = info[suge_isVip];
//    _avatar = info[suge_avatar];
    
    [USER_DEFAULT setObject:_userinfo_username forKey:suge_username];
    [USER_DEFAULT setObject:_userinfo_pwd forKey:suge_pwd];
    [USER_DEFAULT setObject:_userinfo_key forKey:suge_key];
    [USER_DEFAULT setObject:_isVip forKey:suge_isVip];
    [USER_DEFAULT setObject:_avatar forKey:suge_avatar];
    
    [USER_DEFAULT synchronize];
}

-(void)deleteAccountInfo
{
    _userinfo_username = nil;
    _userinfo_pwd = nil;
    _userinfo_key = nil;
    _isVip = nil;
    _avatar = nil;
    
    [USER_DEFAULT setObject:_userinfo_username forKey:suge_username];
    [USER_DEFAULT setObject:_userinfo_pwd forKey:suge_pwd];
    [USER_DEFAULT setObject:_userinfo_key forKey:suge_key];
    [USER_DEFAULT setObject:_isVip forKey:suge_isVip];
    [USER_DEFAULT setObject:_avatar forKey:suge_avatar];

    [USER_DEFAULT synchronize];
    
}

-(BOOL)isLogin
{
    return _userinfo_username != nil;
}

@end
