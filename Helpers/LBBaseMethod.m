//
//  LBBaseMethod.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/19.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBBaseMethod.h"
#import <AFNetworking.h>

@implementation LBBaseMethod

+(void)get:(NSString *)url parms:(NSDictionary *)parms success:(void (^)(id))success failture:(void (^)(id))failture
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];

    [manager GET:url parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            success(responseObject);  //   void(^)(id json)
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failture){
            failture(error);
        }
    }];
    
}

+(void)post:(NSString *)url parms:(NSDictionary *)parms success:(void (^)(id))success failture:(void (^)(id))failture
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];

    [manager POST:url parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failture){
            failture(error);
        }
    }];
}

@end
