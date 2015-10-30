//
//  LBBaseMethod.h
//  SuGeMarket
//
//  Created by 1860 on 15/10/19.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "UtilsMacro.h"
#import "AppMacro.h"
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import <Foundation/Foundation.h>
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"

@interface LBBaseMethod : NSObject
//网络请求的GET方法
+(void)get:(NSString*)url parms: (NSDictionary*)parms success:(void(^)(id json)) success failture:(void(^)(id json)) failture;
//网络请求的POST方法
+(void)post:(NSString*)url parms: (NSDictionary*)parms success:(void(^)(id json)) success failture:(void(^)(id json)) failture;
@end
