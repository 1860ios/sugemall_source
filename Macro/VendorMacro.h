//
//  VendorMacro.h
//  SuGeMarket
//
//  Created by 1860 on 15/4/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#ifndef SuGeMarket_VendorMacro_h
#define SuGeMarket_VendorMacro_h

//---------------支付宝
#define kPartner            @"2088911446894741"
#define kSeller             @"3132526965@qq.com"
#define kPrivateKey             @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMLXN8kv0IvpdlyLnMcr8BjlyOUaR1/N1R/wh+PYixIXhad9yA8PSac/z+uCWKkRWDfjJFbmVXA4Tu4DmC6QxlHszTeJvYd9QTQ3hePquI1QjNF/tXn0mbEu8gQVJ8SL/GwNUQB2zjJIyowKK8h1594BSKvYnco8YQ4t28mLhketAgMBAAECgYBiX4liAcs4qPJCvZa1lQCPgY0R51e8Dk+Z5bammlF1G/02WLJmsCBO2lAfJ1ueWQyCgyN44KiolTV8xMHUWPJXzny/X8MsZpLuiACODQEPJYHvzGZ/7St7pVcB/CvvL1+svsHvAkwnwnrSXDvcl5xrxo3pBW0iLQITS6qIYK0g3QJBAPKZ/Yo0d0Uv4wjeX0AtulHUgwBhA2jqQGzmQKoonNK7989Agh9HC3/wrnCDGQpwVuOFdjwSQl0Ksm/peRDgOfMCQQDNmfahdeP5h3yf134/hP9OdinCyLRhRvkcc7wHK6llcOp4tBSQVlsKh/1ALKbSFiaL/WiCOzYYI2jndI/Biz/fAkEApoIkr5flCLqeU/b0X0NDb2ixZTAwu/CTuWqrlV58jHLw2fHHnZoQfYZ+48BHDpAeQtjWVtKdc+ikogUX0ApmGwJAW7GKmL+nCKYwImlM2K9L3YY9Ya15JNkuSE4lUV1bku4k4+gMM8MPn0a+31wKmi9eyZgef9ZAbct9AZyucDbWKQJADJ46lpS6SFv71k5UG/JEdvq3EB0jJjW2tnkPVNHkt0zkIM5636ucfr6IxxMdlV9WlFfwDmYyKS8toHs2UCqwAQ=="

#define kScheme   @"sugepay"

//---------------微信

#define _APP_ID                 @"wxe0647edc57816c38"
#define kWeiXin_MCH_ID          @"1246954701"
#define kWeiXin_API_KEY         @"412fde4e9cdd2cc619514ecea142e449"
#define kWeiXin_API_SECRET      @"4af4e12665cf3315ba0b26240ecbdcdd"
// 账号帐户资料
//更改商户把相关参数后可测试

#define kWeiXin_APP_ID          @"wxe0647edc57816c38"               //APPID
#define kWeiXin_APP_SECRET      @"4af4e12665cf3315ba0b26240ecbdcdd" //appsecret
//商户号，填写商户对应参数
#define kWeiXin_MCH_ID          @"1246954701"
//商户API密钥，填写相应参数
#define kWeiXin_PARTNER_ID      @"412fde4e9cdd2cc619514ecea142e449"
//支付结果回调页面
#define kWeiXin_NOTIFY_URL      @"http://sugemall.com/mobile/api/payment/wxpay/notify.php"
//获取服务器端支付数据地址（商户自定义）
#define kWeiXin_SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

#define kMob_AppKey @"6e2d24486374"

//---------------银联
#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80
#define kCellHeight_Normal  50
#define kCellHeight_Manual  145

#define kVCTitle          @"商户测试"
#define kBtnFirstTitle    @"获取订单，开始测试"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kMode_Development             @"01"
#define kURL_TN_Normal                @"http://202.101.25.178:8080/sim/gettn"
#define kURL_TN_Configure             @"http://202.101.25.178:8080/sim/app.jsp?user=123456789"

#define UPRelease(X) if (X !=nil) {[X release];X = nil;}

#define UM_KEY  @"557c223067e58e4bc1001ec1"

#endif
