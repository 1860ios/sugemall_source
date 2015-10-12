//
//  LBInvoiceListViewController.h
//  SuGeMarket
//
//  发票列表
//  Created by Josin on 15-4-24.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBInvoiceListViewController : UIViewController
@property (nonatomic, assign) BOOL isChangeInvoice;
@property (nonatomic,copy) void (^backValue)(NSDictionary *invoiceInfo);
@end
