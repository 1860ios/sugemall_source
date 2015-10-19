//
//  LBHttpTool.h
//  SuGeMarket
//
//  Created by 1860 on 15/10/19.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBHttpTool : NSObject
+(void)getWirhUrl:(NSString*)url parms:(NSDictionary*)parms success:(void(^)(id json))success failture:(void(^)(id error))failture;
+(void)postWirhUrl:(NSString*)url parms:(NSDictionary*)parms success:(void(^)(id json))success failture:(void(^)(id error))failture;
@end
