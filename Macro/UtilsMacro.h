//
//  UtilsMacro.h
//  SuGeMarket
//
//  Created by 1860 on 15/4/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

//#import "UIView+RGSize.h"

#ifndef SuGeMarket_UtilsMacro_h
#define SuGeMarket_UtilsMacro_h

#pragma mark - Device Information

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
#define NavigationBar_HEIGHT 64
//tag值
#define TEXTFEILD_TAG    100

#define QIANGGOU_TAG    1929

#define ZHUANTI_TAG    298

#define PICKERVIEW_TAG    2002

#define BTN_TAG     10000

#define ORDER_BTN_TAG     100000

#define TT_TAG      100

#define BTN_NUM_DEL  110
#define BTN_NUM_ADD  120

#define TAG_CLASS_TABLEVIEW_LIFT  111
#define TAG_CLASS_TABLEVIEW_RIGHT  112

#define ORDER_BUTTON_TAG  222

#define SUGE_ADDRESS_TABLE 122

//
#define NAVBAR_CHANGE_POINT 50

#define SEPEC_RIGHTVIEW_DISTANCE 100

//设备
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define EACH_W(A) ([UIScreen mainScreen].bounds.size.width/A)
#define EACH_H 49

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//定义UIImage对象
#define IMAGE(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define SUGE_PIC @"dd_03_@2x"
//ios navbar

#define IOS_NAVBAR          if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){self.edgesForExtendedLayout = UIRectEdgeNone;}

//文件目录
#define APP_DOCUMENT                [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_LIBRARY                 [NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_CACHES_PATH             [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_USERINFO_PATH           userInfoPath()

//function
#define APP_COLOR                       RGBCOLOR(246,39,75)
#define APP_Grey_COLOR                  RGBCOLOR(220,220,220)//RGBCOLOR(245,245,245)
#define APP_TABBAR_COLOR                RGBACOLOR(181,180,180,1)
//下拉刷新
#define APP_REFRESH_FONT_SIZE           FONT(15)
#define APP_REFRESH_TEXT_STATID         @"下拉就可刷新..."
#define APP_REFRESH_TEXT_PULLING        @"松开就可刷新..."
#define APP_REFRESH_TEXT_REFRESHING     @"努力加载中..."

#define APP_BOTTOM_BAR_FAVOTITE         RGBCOLOR(249,200,173)
#define APP_BOTTOM_BAR_ADD_CAR          RGBCOLOR(251,160,167)
#define APP_BOTTOM_BAR_BUY_NOW          RGBCOLOR(254,67,101)


#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define LOCALSTRING(x, ...)         NSLocalizedString(x, nil)
// rgb converter（hex->dec）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define FONT(x) [UIFont systemFontOfSize:x]
#define BFONT(y) [UIFont boldSystemFontOfSize:y]


#endif
