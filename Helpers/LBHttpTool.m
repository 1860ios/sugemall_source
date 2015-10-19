//
//  LBHttpTool.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/19.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBHttpTool.h"
#import "LBBaseMethod.h"

@implementation LBHttpTool

+(void)getWirhUrl:(NSString *)url parms:(NSDictionary *)parms success:(void (^)(id))success failture:(void (^)(id))failture
{
    [LBBaseMethod get:url parms:parms success:^(id json) {
        
        if(success){
            success(json);
        }
    } failture:^(id json) {
        if(failture){
            failture(json);
        }
    }];
}
+(void)postWirhUrl:(NSString *)url parms:(NSDictionary *)parms success:(void (^)(id))success failture:(void (^)(id))failture
{
    [LBBaseMethod post:url parms:parms success:^(id json) {
        
        if(success){
            success(json);
        }
    } failture:^(id json) {
        if(failture){
            failture(json);
        }
    }];
}

@end
