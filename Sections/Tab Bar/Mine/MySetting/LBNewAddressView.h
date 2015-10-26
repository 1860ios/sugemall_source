//
//  LBNewAddressView.h
//  SuGeMarket
//
//  Created by 1860 on 15/4/27.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LBNewAddressView : UIViewController

@property (nonatomic, assign) BOOL isEdict;
@property (nonatomic, assign) NSString *address_id;
@property (nonatomic, retain) NSString *_trueName;
@property (nonatomic, retain) NSString *_telPhone;
@property (nonatomic, retain) NSString *_address;
@property (nonatomic, retain) NSString *_areaInfo;
@property (nonatomic, retain) NSString *_navTitle;
@property (nonatomic, copy) NSString *setTag;
@property(nonatomic,copy)void(^block) (NSString *);



@end

