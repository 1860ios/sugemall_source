//
//  SUGE_API.h
//  SuGeMarket
//
//  Created by 1860 on 15/4/21.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#ifndef SuGeMarket_SUGE_API_h
#define SuGeMarket_SUGE_API_h

#define SUGE_BASE_URL   @"http://test.sugemall.com/mobile/" //前缀

/**
 *  设为默认
 */
#define SUGE_SET_MOREN [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_address&op=address_set_default"]



/**
 * 消息
 */
#define SUGE_NEWS     [SUGE_BASE_URL stringByAppendingString:@"index.php?act=suge_message"]


/**
 * 一级分类
 */
#define SUGE_1_FENLEI     [SUGE_BASE_URL stringByAppendingString:@"index.php?act=suge_category"]


/**
 * 抢购
 */
#define SUGE_GROUP_BUY     [SUGE_BASE_URL stringByAppendingString:@"index.php?act=suge_groupbuy"]


/**
 *  红包
 */

#define SUGE_REDBAG     [SUGE_BASE_URL stringByAppendingString:@"index.php?act=predeposit&op=activity"]

/**
 *  专属二维码
 */

#define SUGE_QR   [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_offline&op=get_share_link"]


/**
 *  订单详情
 key
 order_id 订单编号
 */

#define SUGE_DETAIL_ORDER   [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_order&op=order_detail"]


/**
 *  订单删除
 请求参数
 
 order_id 订单编号（如果批量操作，多个订单编号用逗号隔开，并删除最后一个逗号）
 key 当前登录令牌
 */
#define SUGE_DEL_ORDER        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_order&op=order_recycle"]

/**
 *  订单恢复
 order_id 订单编号（如果批量操作，多个订单编号用逗号隔开，并删除最后一个逗号）
 key 当前登录令牌
 */
#define SUGE_RE_ORDER        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_order&op=order_restore"]

/**
 *  订单回收站
 */
#define SUGE_RE        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_order&op=order_restore"]


/**
 *  退款/退货页面订单、商品信息
 POST:
 *	key
 order_id
 goods_id
 
 返回：
 *	reason_list	退款原因
 *	goods	退款商品信息
 *	order	退款订单信息
 */

#define SUGE_REFUND_PAGE        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_refund&op=add_refund_page"]
/**
 *  退款/退货申请接口
 POST:
 *	key
 *	refund_amount 退款金额
 *	goods_num	退款数量
 *	reason_id	原因
 *	refund_pic1 , refund_pic2 , refund_pic3	图片
 *	refund_type	类型:1为退款,2为退货
 *	buyer_message	退款说明

 */
#define SUGE_ADD_REFUND        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_refund&op=add_refund_all"]

/**
 *  .退款记录列表
 GET:
 *	key
 *	curpage 	页码
 *	type 1为退款,2为退货,默认为1
 */
#define SUGE_REFUND_INDEX        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_refund&op=index"]

/**
 *  判断是否有支付密码
 */

#define SUGE_IS_HAV_PAYMM        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=is_set_paypwd"]

/**
 *  判断是否有邮箱
 */
#define SUGE_IS_HAV_EMAIL        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=is_bind_email"]

/**
 *  向原电子邮箱发送验证码
 */
#define SUGE_SEND_EMAIL_VCODE        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=send_auth_code_email"]


/**
 *  绑定新邮箱
 */
#define SUGE_BLING_EMAIL        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=send_bind_email"]

/**
 *  绑定新的手机号
 */
#define SUGE_BLING_MOB        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=bind_mobile"]



/**
 *  判断是否绑定手机号
 */
#define SUGE_IS_BLING_MOB        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=is_bind_mobile"]

/**
 *  V手机号验证 - 发送验证码
 */
#define SUGE_SEND_VCODE        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=send_auth_code"]

/**
 *  设置支付密码
 *  请求参数（POST）
	*	key
	*	vcode			验证码
	*	password		密码
	*	confirm_password	密码
	*	mobile			手机号

 */
#define SUGE_SET_PAY_MM        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=modify_paypwd"]





/*
 请求参数（POST）
	key=登录令牌
	bankcard_number=银行卡号
	bank_id=开户行
	account_name=开户名
	id_card=开户人身份证号

 */
//添加银行卡
#define SUGE_ADDBANK       [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_extends&op=add_bank_card"]


/*
 请求参数(POST)
	key=6246ccdfcfa5fc671a67f68945b45609
	bankcard_id=银行卡主键
 */
//删除银行卡：
#define SUGE_DELBANK       [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_extends&op=delete_bank_card"]


/*
 key = 6246ccdfcfa5fc671a67f68945b45609
	bankcard_id = 银行卡主键
 */
//设为默认银行卡
#define SUGE_DEFAULTBANK       [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_extends&op=set_default_card"]


/*
 返回参数
	bank_id=银行主键
	bank_name=银行名称， 如中国工商银行
	bank_logo=银行logo图标

 */
//可用银行列表
#define SUGE_OPLISTBANK       [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_extends&op=bank_list"]


/**
 *  请求参数
 
 bank  银行全称
 
 返回数据
 
 所有省份
 
 *///银行所在省份
#define SUGE_BANK_PROVINCE              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=bank_code&op=list_bank_province"]
/**
 *  请求参数
 
 bank = 银行全称
	prv = 省份
 
 返回数据
 
 所有城市
 
 *///银行所在城市
#define SUGE_BANK_AREA              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=bank_code&op=list_bank_area"]
/**
 *  请求参数
 
	bank = 银行全称
	prv = 省份
	area = 城市
 
 返回：
	name => 支行名
	code => 支行行号
 
 *///银行所在支行
#define SUGE_BANK_SUBBRANCH              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=bank_code&op=list_bank_name"]

/*
 
 返回参数: 列表-子项
	bankcard_id=银行卡主键
	bankcard_number=银行卡号
	bank_logo=银行logo图标
	bank_name=银行名称
	bank_short_name=银行简称（比如中国工商银行简称工商银行）
	account_name=开户名
	id_card=开户人身份证号
	is_default = 1为是默认，0非默认
 */
//银行卡列表
#define SUGE_LISTBANK        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_extends&op=list_bank_card"]

/**
 *  验证code
 */
#define SUGE_CHECK_EMAIL_CODE       [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=check_vcode"]

//
/**
 *  .上传头像
 */
#define SUGE_UPLOAD       [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_information&op=upload"]
//
/**
 *  提交头像裁剪参数，并保存头像
 */
#define SUGE_CUT       [SUGE_BASE_URL stringByAppendingString:@"index.php?act=index&op=cut"]//

///**
// *  <#Description#>
// */
//#define SUGE_ADDBANK       [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_extends&op=add_bank_card"]


///
//申请提现接口
/*
 POST以下参数：
 key=6246ccdfcfa5fc671a67f68945b45609
 pdc_bank_name=银行名
 pdc_bank_no=卡号
 pdc_bank_user=持卡人名
 password=支付密码
 pdc_amount=申请提现金额
 */
#define SUGE_PD_CASH_ADD     [SUGE_BASE_URL stringByAppendingString:@"index.php?act=predeposit&op=pd_cash_add"]


//申请提现历史记录
/*
 POST以下参数：
 key=6246ccdfcfa5fc671a67f68945b45609
 sn_search = 寻找申请提现单号，可为空
 paystate_search = 支付状态 1为已支付，0未支付，为空所有
 */
#define SUGE_PD_CASH_LIST     [SUGE_BASE_URL stringByAppendingString:@"index.php?act=predeposit&op=pd_cash_list"]


//佣金变动记录详情
/*
 POST
 key=6246ccdfcfa5fc671a67f68945b45609
 */
#define SUGE_PD_LOG_LSIT     [SUGE_BASE_URL stringByAppendingString:@"index.php?act=predeposit&op=pd_log_list"]


//申请提现记录详情
/*
 POST:
 key=6246ccdfcfa5fc671a67f68945b45609
 id=1  //即列表中的 pdc_id
 */
#define SUGE_PD_CASH_INFO     [SUGE_BASE_URL stringByAppendingString:@"index.php?act=predeposit&op=pd_cash_info"]


////
//#define SUGE_PD_CASH     [SUGE_BASE_URL stringByAppendingString:@""]
//
//#define SUGE_PD_CASH     [SUGE_BASE_URL stringByAppendingString:@""]
///
/**
 *请求参数  key
 返回数据 qrcode_url 二维码生成地址
*/
 //消息推送
#define SUGE_MSG  [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_index&op=msg_list"]
 

//我的积分
//1
//#define SUGE_MYPOINT_1  [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_index&op=my_uid"]

//2
#define SUGE_MYPOINT_2  [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_offline&op=my_points"]

/**
 *  GENGXIN
 */
#define SUGE_VERSION  [SUGE_BASE_URL stringByAppendingString:@"?act=index&op=ios_version"]


// 推荐用户下载APP二维码生成
#define SUGE_QRCODEURL  [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_offline&op=qrcode_rec&key="]

/*
 获取分类列表
 
 接口调用（POST/GET）
 index.php?act=suge_article_class&op=article_class
 
 请求参数
 ac_id 分类id  空-返回一级分类
 
 返回数据
 
 article_class_list 分类列表
 
 ac_id 分类id
 ac_code 分类识别码
 ac_name 分类名称
 ac_parent_id 分类父id
 ac_pic 分类图标
 
 **/
#define SUGE_NEWHANDSTEP1             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=suge_article_class&op=article_class"]

//设置密码
#define SUGE_SET_PWD  [SUGE_BASE_URL stringByAppendingString:@"index.php?act=login&op=setup_password"]

//忘记密码
#define SUGE_FORGET_PWD   [SUGE_BASE_URL stringByAppendingString:@"index.php?act=login&op=forget_password"]


//获取忘记验证码
#define SUGE_GET_SETUP_VCODE   [SUGE_BASE_URL stringByAppendingString:@"index.php?act=login&op=send_setup_mobile"]


//获取验证码
#define SUGE_GETVCODE   [SUGE_BASE_URL stringByAppendingString:@"index.php?act=login&op=send_register_mobile"]

//第三方快速注册
#define SUGE_QUIKREGISTER [SUGE_BASE_URL stringByAppendingString:@"index.php?act=login&op=quick_register"]

//第三方快速登录
#define SUGE_QUIKRELOGIN  [SUGE_BASE_URL stringByAppendingString:@"index.php?act=login&op=quick_login"]
/**
 *  获得我的一级下线
 
 返回：
 member_id //会员id
 member_name  //会员名
 member_points	//当前积分
 member_avatar  //头像
 join_time     //加入时间
 
 */

#define SUGE_OFFLINE    [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_offline&op=my_group"]

//商城API
//sugemall.com/mobile/
//suge2.4gxt.cn/mobile

//@"http://192.168.0.124/mobile/" //前缀
/**
 *  请求参数
 
 type json/html json格式或者html页面
 
 返回数据
 
 adv_list
 home1
 home2
 home3
 home4
 goods
 
 返回数据说明
 
 image 图片地址
 type 操作类型
 keyword 搜索关键字
 special 专题编号
 goods 商品编号
 url 地址
 data 与操作类型对应的数据内容
 
 
 *///首页
#define SUGE_HOME                [SUGE_BASE_URL stringByAppendingString:@"index.php?act=index"] //首页数据

/**
 *  请求参数
 
 special_id 专题编号
 type json/html json格式或者html页面
 
 返回数据
 
 adv_list
 home1
 home2
 home3
 home4
 goods
 
 返回数据说明
 
 image 图片地址
 type 操作类型
 keywork 搜索关键字
 special 专题编号
 goods 商品编号
 url 地址
 data 与操作类型对应的数据内容
 
 
 *///专题
#define SUGE_SPECIAL             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=index&op=special"]//专题数据
//商品分类
/**
 *   有下级分类返回分类列表，无分类返回'0'
 */
#define SUGE_ONELEVEL_CLASS       [SUGE_BASE_URL stringByAppendingString:@"index.php?act=goods_class"]//商品一级分类

/**
 *  请求参数
 
 key 排序方式 1-销量 2-浏览量 3-价格 空-按最新发布排序
 order 排序方式 1-升序 2-降序
 page 每页数量
 curpage 当前页码
 gc_id 分类编号
 keyword 搜索关键字
 gc_id和keyword二选一不能同时出现
 
 返回数据
 
 goods_id 商品编号
 goods_name 商品名称
 goods_price 商品价格
 goods_marketprice 商品市场价
 goods_salenum 销量
 evaluation_good_star 评价星级
 evaluation_count 评价数
 group_flag 是否抢购
 xianshi_flag 是否限时折扣
 goods_image 图片名称
 goods_image_url 图片地址
 is_fcode 是否为F码商品 1-是 0-否
 is_appoint 是否是预约商品 1-是 0-否
 is_presell 是否是预售商品 1-是 0-否
 have_gift 是否拥有赠品 1-是 0-否
 
 
 *///商品列表
#define SUGE_GOODS_LIST          [SUGE_BASE_URL stringByAppendingString:@"index.php?act=goods&op=goods_list"]//商品列表


/**
 *  请求参数
 
 goods_id 商品编号
 
 返回数据
 
 goods_info 商品信息
 goods_name 商品名称
 goods_jingle 商品说明
 spec_name 规格名称
 spec_value 规格名
 goods_price 商品价格
 goods_marketprice 商品市场价
 goods_id 商品编号
 goods_click 商品点击数
 goods_commentnum 商品评论数
 goods_salenum 商品销量
 goods_spec 商品规格
 goods_storage 商品库存
 evaluation_good_star 评价等级
 evaluation_count 评价数
 promotion_type 促销类型 groupbuy-抢购 xianshi-限时折扣
 promotion_price 促销价格
 upper_limit 最多购买数
 is_virtual 是否为虚拟商品 1-是 0-否
 virtual_indate 虚拟商品有效期
 virtual_limit 虚拟商品购买上限
 is_fcode 是否为F码商品 1-是 0-否
 is_appoint 是否是预约商品 1-是 0-否
 is_presell 是否是预售商品 1-是 0-否
 have_gift 是否拥有赠品 1-是 0-否
 spec_list 规格列表
 gift_array 赠品数组
 spec_image 规格图片
 goods_image 商品图片
 goods_commend_list 推荐商品列表
 mansong_info 满即送信息
 mansong_name 活动名称
 start_time 开始时间
 end_time 结束时间
 price 活动金额
 discount 减现金
 mansong_goods_name 赠送商品名称
 goods_id 赠送商品编号
 goods_image_url 赠送商品图片地址
 
 
 *///商品详请信息
#define SUGE_GOODS_DETAIL        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=goods&op=goods_detail"]

//商店详情
#define SUGE_STORE_DETAIL              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=store&op=store_detail"]
/**
*GET请求：
key=	4 新品，3 价格	，2销量，1 人气（同普通商品列表）
page=	页面记录数；
curpage=	页码
store_id= 店铺ID

返回：
同普通商品列表*/
//商店商品列表
#define SUGE_STORE_LIST        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=store&op=goods_list"]
/**
 *  请求参数
 
 goods_id 商品编号
 
 返回数据
 
 html
 
 
 *///商品介绍信息
#define SUGE_GOODS_BODY          [SUGE_BASE_URL stringByAppendingString:@"index.php?act=goods&op=goods_body"]

/**
 *  请求参数
 
 username 用户名
 password 密码
 client 客户端类型(android wap ios wechat)
 
 返回数据
 
 username 用户名
 key 登录令牌
 
 
 *///登录
#define SUGE_LOGIN                    [SUGE_BASE_URL stringByAppendingString:@"index.php?act=login"]

/**
 *  请求参数
 
 username 用户名
 password 密码
 password_confirm 密码确认
 email 邮箱
 client 客户端类型(android wap ios wechat)
 
 返回数据
 
 username 用户名
 key 登录令牌
 
 
 *///注册
#define SUGE_REGISTER                 [SUGE_BASE_URL stringByAppendingString:@"index.php?act=login&op=register"]

/**
 *  请求参数
 
 username 用户名
 key 当前登录令牌
 client 客户端类型(android wap ios wechat)
 
 返回数据
 
 '1'
 
 
 *///注销
#define SUGE_LOGOUT                    [SUGE_BASE_URL stringByAppendingString:@"index.php?act=logout"]


///
#define SUGE_ISVIP                    [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_index&op=is_vip"]

/**
 *请求参数
 
 key 当前登录令牌
 
 返回数据
 
 username 用户名
 avator 用户头像
 point 积分
 predepoit 预存款
 
 
 *///我的商城
#define SUGE_MY_SUGE                    [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_index"]

/**
 *  查找并获取该幸运号归属用户（用于提醒用户是否设置推荐人为该用户）
 POST:
 
 uid
 key
 */

#define SUGE_SEARCH_USER         [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_index&op=search_user"]

/**
 *  设置为推荐人
 POST:
 uid
 key

 */
#define SUGE_SET_INVITER         [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_index&op=set_inviter"]




/**
 *  请求参数
 
 key 当前登录令牌
 
 返回数据
 
 goods_name 商品名称
 goods_image_url 商品图片地址
 goods_price 商品价格
 fav_id 收藏编号
 
 
 *///收藏列表
#define SUGE_FAVORITE_LIST              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_favorites&op=favorites_list"]

/**
 *  请求参数
 
 goods_id 商品编号
 key 当前登录令牌
 
 返回数据
 
 '1'
 
 
 *///收藏添加
#define SUGE_FAVORITE_ADD              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_favorites&op=favorites_add"]


/**
 *  请求参数
 
 fav_id 收藏编号
 key 当前登录令牌
 
 返回数据
 
 '1'
 
 
 *///收藏删除
#define SUGE_FAVORITE_DEL             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_favorites&op=favorites_del"]


/**
 *  请求参数
 
 key 当前登录令牌
 
 返回数据
 
 address_list
 city_id 城市编号
 area_id 地区编号
 area_info 地址
 address 详细地址
 tel_phone 固定电话机
 mob_phone 手机
 
 
 *///地址列表
#define SUGE_ADDRESS_LIST              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_address&op=address_list"]

/**
 *  设为默认地址
 */

#define SUGE_SETDEFAULT_ADDRESS        [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_address&op=address_set_default"]


/**
 *  请求参数
 
 key 当前登录令牌
 address_id 地址编号
 
 返回数据
 
 area_info 地址
 address 详细地址
 tel_phone 固定电话机
 mob_phone 手机
 
 
 *///地址详细信息
#define SUGE_ADDRESS_INFO              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_address&op=address_info"]


/**
 *  请求参数
 
 key 当前登录令牌
 address_id 地址编号
 
 返回数据
 
 '1'
 
 
 *///地址删除
#define SUGE_ADDRESS_DEL              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_address&op=address_del"]


/**
 *  请求参数
 
 key 当前登录令牌
 true_name 姓名
 city_id 城市编号(地址联动的第二级)
 area_id 地区编号(地址联动的第三级)
 area_info 地区信息，例：天津 天津市 红桥区
 address 地址信息，例：水游城8层
 tel_phone 电话号码
 mob_phone 手机
 
 返回数据
 
 address_id
 
 
 *///地址添加
#define SUGE_ADDRESS_ADD              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_address&op=address_add"]


/**
 *  请求参数
 
 key 当前登录令牌
 address_id 地址编号
 true_name 姓名
 area_id 地区编号
 city_id 城市编号
 area_info 地区信息，例：天津 天津市 红桥区
 address 地址信息，例：水游城8层
 tel_phone 电话号码
 mob_phone 手机
 
 返回数据
 
 '1'
 
 
 *///地址编辑
#define SUGE_ADDRESS              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_address&op=address_edit"]


/**
 *  请求参数
 
 key 当前登录令牌
 area_id 地区编号(为空时默认返回一级分类)
 
 返回数据
 
 area_id 地区编号
 area_name 地区名称
 
 
 *///地区列表
#define SUGE_AREA_LIST              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_address&op=area_list"]


/**
 *  请求参数
 
 key 当前登录令牌
 
 返回数据
 
 order_group_list
 order_list 订单列表
 order_id 订单id
 order_sn 订单sn
 store_name 店铺名称
 goods_amount 商品总价
 order_amount 订单总价
 pd_amount 预存款支付总价
 shipping_fee 运费
 state_desc 状态文字
 payment_name 支付方式文字
 if_cancel 是否显示取消按钮 true/false
 if_receive 是否显示确认收货按钮 true/false
 if_lock 是否显示锁定中状态 true/false
 if_deliver 是否显示查看物流按钮 true/false
 extend_order_goods 订单商品列表
 goods_name 商品名称
 goods_price 商品价格
 goods_num 商品购买数量
 goods_image_url 商品图片地址
 pay_amount 支付总额，该字段存在且大于0时显示支付按钮
 add_time 订单提交时间
 pay_sn 支付编号
 
 订单状态
 
 0-已取消
 10-未支付
 20-已支付
 30-已发货
 40-交易成功
 
 
 *///订单列表
#define SUGE_ORDER_LIST              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_order&op=order_list"]


/**
 *  请求参数
 
 key 当前登录令牌
 order_id 订单编号
 
 返回数据
 
 '1'
 
 
 *///订单取消(未付款)
#define SUGE_ORDER_CANCEL              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_order&op=order_cancel"]


/**
 *  请求参数
 
 key 当前登录令牌
 order_id 订单编号
 
 返回数据
 
 '1'
 
 
 *///订单确认收货
#define SUGE_ORDER_RECEIVE              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_order&op=order_receive"]


/**
 *  请求参数
 
 key 当前登录令牌
 order_id 订单编号
 
 返回数据
 
 express_name 物流公司名称
 shipping_code 物流编号
 deliver_info 物流信息
 
 
 *///订单物流信息
#define SUGE_SEARCH_DELIVER              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_order&op=search_deliver"]


/**
 *  请求参数
 
 key 当前登录令牌
 
 返回数据
 
 cart_list
 cart_id 购物车编号
 buyer_id 买家member_id
 store_id 店铺编号
 store_name 店铺名称
 goods_id 商品编号
 goods_name 商品名称
 goods_price 商品价格
 goods_num 购买数量
 goods_image_url 图片地址
 goods_sum 商品总价
 sum 购物车总价
 
 
 *///购物车列表
#define SUGE_CAR_LIST              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_cart&op=cart_list"]
//sugemall.com/mobile/index.php?act=member_cart&op=cart_store_list


/**
 *  请求参数
 
 key 当前登录令牌
 goods_id 商品编号
 quantity 购买数量
 
 返回数据
 
 '1'
 
 
 *///购物车添加
#define SUGE_CAR_ADD              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_cart&op=cart_add"]


/**
 *  请求参数
 
 key 当前登录令牌
 cart_id 购物车编号
 
 返回数据
 
 '1'
 
 
 *///购物车删除
#define SUGE_CAR_DEL              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_cart&op=cart_del"]


/**
 *  请求参数
 
 key 当前登录令牌
 cart_id 购物车编号
 quantity 新的购买数量
 
 返回数据
 
 quantity 购买数量
 goods_price 商品价格
 total_price 商品总价
 
 
 *///购物车修改数量
#define SUGE_CAR_EDIT_QUANTITY              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_cart&op=cart_edit_quantity"]


/**
 *  请求参数
 
 key 当前登录令牌
 
 返回数据
 
 invoice_list
 inv_id 发票编号
 inv_title 发票抬头
 inv_content 发票内容
 
 
 *///发票列表
#define SUGE_INVOICE_LIST              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_invoice&op=invoice_list"]


/**
 *  请求参数
 
 key 当前登录令牌
 inv_title_select 发票类型，可选值：person(个人) company(单位)
 inv_title 发票抬头(inv_title_select为company时需要提交)
 inv_content 发票内容，可通过invoice_content_list接口获取可选值列表
 
 返回数据
 
 inv_id 发票编号
 
 
 *///发票添加
#define SUGE_INVOICE_ADD              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_invoice&op=invoice_add"]


/**
 *  请求参数
 
 key 当前登录令牌
 inv_id 发票编号
 
 返回数据
 
 '1'
 
 
 *///发票删除
#define SUGE_INVOICE_DEL              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_invoice&op=invoice_del"]


/**
 *  请求参数
 
 key 当前登录令牌
 
 返回数据
 
 invoice_content_list
 
 
 *///发票内容列表
#define SUGE_INVOICE_CONTENT_LIST              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_invoice&op=invoice_content_list"]


/**
 *  请求参数
 
 key 当前登录令牌
 cart_id 购买参数
 ifcart 购物车购买标志 1
 
 cart_id说明
 
 立即购买： 第一个数字为商品编号，第二个数字为购买数量，用竖线分割。例：232|1
 购物车购买：第一个数字为购物车编号，第二个数字为购买数量，用竖线分割。多组用半角逗号分割，例：232|1,110|2 232商品购买1个，110商品购买2个
 
 返回数据
 
 ifcart 购物车购买标志 1
 store_cart_list 购物车列表 店铺编号为下标的数组
 goods_list 商品列表
 goods_num 购买数量
 goods_id 商品编号
 goods_commonid 商品通用编号
 store_id 店铺编号
 goods_name 商品名称
 goods_price 商品价格
 goods_image_url 商品图片
 transport_id 运费模板编号
 goods_freight 运费
 goods_storage 库存
 state 商品是否有效 true
 storage_state
 cart_id 购物车编号
 bl_id 组合销售编号
 promotions_id
 ifxianshi
 premiums 赠品标志 true
 goods_total 总价
 store_goods_total 店铺商品总价 店铺编号为下标的数组
 store_mansong_rule_list 满送规则列表 店铺编号为下标的数组
 store_vouche_list 店铺代金券列表 数组下标是voucher_t_id
 freight 0-免运费 1-需要计算运费
 freight_message 免运费时的说明
 store_name 店铺名称
 freight_hash 运费hash，选择地区时作为参数提交
 address_info 收货地址信息
 ifshow_offpay 支持货到付款时为true
 vat_hash 发票信息hash
 inv_info 发票信息
 available_predeposit 可用预存款
 
 
 *///购买第一步
#define SUGE_BUY_STEP1              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_buy&op=buy_step1"]


/**
 *  请求参数
 
 key 当前登录令牌
 freight_hash 运费hash，第一步返回结果里有直接提交
 city_id 城市编号
 area_id 地区编号
 
 返回数据
 
 content 运费列表，以店铺编号为下标数组，值为运费
 allow_offpay 是否允许货到付款 1-允许 0-不允许
 offpay_hash 货到付款hash
 offpay_hash_batch 店铺是否支持货到付款hash
 
 
 *///更换收货地址
#define SUGE_CHANGE_ADDRESS              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_buy&op=change_address"]


/**
 *  请求参数
 
 key 当前登录令牌
 password 用户支付密码
 
 返回数据
 
 '1'
 
 
 *///验证支付密码
#define SUGE_CHECK_PASSWORD              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_buy&op=check_password"]


/**
 *  请求参数
 
 key 当前登录令牌
 ifcart 购物车购买标志 1
 cart_id 购买参数
 address_id 收货地址编号
 vat_hash 发票信息hash，第一步接口提供
 offpay_hash 是否支持货到付款hash，通过更换收货地址接口获得
 offpay_hash_batch 店铺是否支持货到付款hash
 pay_name 付款方式，可选值 online(线上付款) offline(货到付款)
 invoice_id 发票信息编号
 voucher 代金券，内容以竖线分割 voucher_t_id|store_id|voucher_price，多个店铺用逗号分割，例：10|2|10,1|3|10
 pd_pay 是否使用预存款支付 1-使用 0-不使用
 password 用户支付密码，启动预存款支付时需要提交
 fcode F码购买时需提交
 
 cart_id说明
 
 立即购买： 第一个数字为商品编号，第二个数字为购买数量，用竖线分割。例：232|1
 购物车购买：第一个数字为购物车编号，第二个数字为购买数量，用竖线分割。多组用半角逗号分割，例：232|1,110|2 232商品购买1个，110商品购买2个
 
 返回数据
 
 pay_sn 支付编号
 
 
 *///购买第二步
#define SUGE_BUY_STEP2              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_buy&op=buy_step2"]


/**
 *  请求参数
 
 key 当前登陆令牌
 
 返回数据
 
 payment_list 可用支付方式列表(wxpay-微信支付 alipay-支付宝移动支付)
 
 
 *///可用支付方式列表
#define SUGE_PAYMENT_LIST              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_payment&op=payment_list"]


/**
 *  请求参数
 
 key 当前登录令牌
 pay_sn 支付编号
 
 
 *///支付
#define SUGE_PAY              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_payment&op=pay"]


/**
 *  请求参数
 
 key 当前登录令牌
 voucher_state 代金券状态(1-未使用 2-已使用 3-已过期)
 
 返回数据
 
 voucher_list 代金券列表
 voucher_id 代金券编号
 voucher_code 代金券编码
 voucher_title 代金券标题
 voucher_desc 代金券描述
 voucher_start_date 代金券开始时间
 voucher_end_date 代金券过期时间
 voucher_price 代金券面额
 voucher_limit 代金券使用限额
 voucher_state 代金券状态编号
 voucher_order_id 使用代金券的订单编号
 voucher_store_id 店铺编号
 store_name 店铺名称
 store_id 店铺编号
 store_domain 店铺域名
 voucher_t_customimg 代金券图片
 voucher_state_text 代金券状态文字
 
 
 *///买家代金券列表
#define SUGE_VOUCHER_LIST              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_voucher&op=voucher_list"]


/**
 *  请求参数
 
 key 当前登录令牌
 feedback 反馈内容
 
 返回数据
 
 '1'
 
 
 *///意见反馈
#define SUGE_FEEDBACK_ADD              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_feedback&op=feedback_add"]

/**
 * 传参：POST
 key 用户key值
 
 返回值：
 sum 累计收益（元）
 predepoit.available 可提现佣金（元）
 points.available 积分（元）
 rc.available 余额
 
 predepoit.p0 储值返利（元）
 predepoit.p1 提现中（元）
 predepoit.p2 已提现（元）
 
 直接收款： 暂无内容
 
 *///财富
#define SUGE_WEATH              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_index&op=wallet"]
//cd8451ed9dc7a21718f62087c8fbf007
//mobile/index.php?act=member_index&op=wallet

/*
 传参：POST
 key 用户key值
 pdr_amount 充值金额(参数的值：1000，充值1000元、2000，充值2000元、3000，充值3000元)
 
 返回值：
 pay_sn 充值单号
 pdr_amount 充值金额
 */
#define SUGE_RECHARGE              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=predeposit&op=recharge_add"]

//#define SUGE_TEST_URL   @"http://test.sugemall.com/mobile/"
/*
 传参：POST
 key :  用户key
 truename :  真实姓名
 idcard :  身份证号
 返回值：
 成功返回
 1
 失败返回
 error 错误信息
 */
#define SUGE_AUTHENTICATION              [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=modify_authinfo"]
/**
 请求参数
 ac_code 分类识别码；多个用逗号隔开例如:faq,video；faq代表常见问题，video代表视频，buiness代表商学院
 has_child 是否调用子分类 1是调用，0和空是不调用
 
 返回数据
 article_class_list 分类列表
 
 ac_id 分类id
 ac_code 分类识别码
 ac_name 分类名称
 ac_parent_id 分类父id
 ac_pic 分类图标
 child 该分类下子分类列表(当has_child参数设置1时)
 ac_id
 ac_code
 ac_name
 ac_parent_id
 ac_pic
 */
#define SUGE_NEWHAND             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=suge_article_class&op=article_class_bycode"]
/**
 普通文章列表
 
 请求参数
 ac_id 分类id
 page 页码数
 
 返回数据
 article_list 文章列表
 article_id 文章id
 article_title 文章标题
 */
#define SUGE_CONTENT             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=suge_article"]

/**
 视频列表
 
 请求参数
 ac_id 视频分类id
 page 页码数
 
 返回数据
 video_list 视频列表
 article_id 视频id
 article_title 视频标题
 article_cover 视频封面图
 article_views 视频浏览量
 */
#define SUGE_VIDEO             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=suge_article&op=video_list"]
/**
 请求参数
 article_id 文章id
 
 返回数据
 
 article_detail 文章详情
 article_id 文章id
 article_title 文章标题
 article_content 文章内容
 article_time 发布时间 Unix 时间戳，请自行处理需要的格式
 article_author 文章作者
 article_cover 文章封面
 article_views 文章浏览量
 */
#define SUGE_TEXT             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=suge_article&op=article_detail"]
/*
 请求参数
 
 goods_id 商品id
 key
 返回数据
 
 1 正确
 error 错误信息
 */
#define SUGE_ANOTHER             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_buy&op=in_active"]
/*
 请求参数
 
 pay_sn 订单支付单号
 key 用户秘钥
 返回数据
 
 order_list 订单商品列表
 pay_amount 订单总额
 发起代付前获取随机留言(post)
 
 请求参数
 
 key 用户秘钥
 type 1发起代付时留言/2朋友代付时留言
 返回数据
 
 datas 留言语句字符串
 */
#define SUGE_PAYANOTHER1             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_buy&op=pay_sn_detail"]

#define SUGE_ADDRESSLIST             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_teams&op=team_book"]

#define SUGE_CUSTOMLIST             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_teams&op=team_custom"]

#define SUGE_PARTNER             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_teams&op=team_partner"]

/*
 请求参数
 
 name 用户姓名
 idcard 身份证号码
 key 用户登录token
 返回数据
 
 0 核对失败，1 核对成功，2 没有实名认证
 */
#define SUGE_VALIDATEID             [SUGE_BASE_URL stringByAppendingString:@"index.php?act=member_security&op=check_identity"]

#endif
