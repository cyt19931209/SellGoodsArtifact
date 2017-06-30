//
//  AppMacro.h
//  MACALLINE
//
//  Created by comnslog on 9/23/15.
//  Copyright © 2015 comnslog. All rights reserved.
//

#import "HXAppMacro.h"

#ifndef HXAppMacro
#define HXAppMacro

/**
 *  app相关的宏定义
 */

// 控制测试环境和真实环境之间的切换
// 测试环境：0
// 真实环境：1
#define IS_FORMAL 1

// 判定发布方式
// 企业内测版：0
// AppStore：1
#define IS_APP_STORE 1


/******************************************************************************
 *  各种请求根地址
 ******************************************************************************/

#define CONTACT(x, y) [NSString stringWithFormat:@"%@%@", (x), (y)]
#define GET_URL(scheme, hostAndPort, path) CONTACT(CONTACT(scheme, hostAndPort), path)

// API根域名
#define ROOT_URL_HOST_FOR_API_FORMAL @"www.sheyigou.com"
#define ROOT_URL_HOST_FOR_API_TEST @"www.sheyigou.com"


// 当前版本号
#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]




// API调用根地址
#define __API_ROOT_IP_HTTP GET_URL(@"http://", ROOT_URL_HOST_FOR_API, @"/clientv30/api.do")

#define __API_ROOT_UPLOADIMAGE_HTTP_URL GET_URL(@"http://", ROOT_URL_HOST_FOR_API, @"/clientv30/imgupload.do")

//测试
#define RSASyg_Public_key_TEST @"-----BEGIN PUBLIC KEY-----\
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC+4wMxpYajfEuizAZxreikjQY0\
AjrtnKnnVl7w3wcojB0iLeKOWHsegQG1vkkYVtCgNCv77Qeyvr8hvAJ9g9368/O4\
Bn/xvGMQ70wsKg17TnVqPhO0PiWvEGm1hbvngP2bjBkiDAethauFtzfDuU30aqVn\
Ze/xkA1niULxk8ELbwIDAQAB\
-----END PUBLIC KEY-----"

//生产
#define RSASyg_Public_key_FORM @"-----BEGIN PUBLIC KEY-----\
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHKH08EnQVpihA46tTgz0QxsBw\
zw/qW++EwaR1eQrmeedUzUj/BVNyNe7YoSoTgC7dPt5YmVFyxYSfT9C/Ah5G8XvX\
LjioCqwVQzt/FUlPl7p8Ckj6dcX4F8pHKxQBy1Ns3jY9MNxCgUb5ptjdBU6Zst4R\
ThOIx/M9y0f07KZngwIDAQAB\
-----END PUBLIC KEY-----\
"

#define RSASyg_Private_key_FORM @"-----BEGIN GHRSA PRIVATE KEY-----\
MIICXAIBAAKBgQDHKH08EnQVpihA46tTgz0QxsBwzw/qW++EwaR1eQrmeedUzUj/\
BVNyNe7YoSoTgC7dPt5YmVFyxYSfT9C/Ah5G8XvXLjioCqwVQzt/FUlPl7p8Ckj6\
dcX4F8pHKxQBy1Ns3jY9MNxCgUb5ptjdBU6Zst4RThOIx/M9y0f07KZngwIDAQAB\
AoGANpZPdSatsL1hLR/59qLzGuUPHBx1BUx7owycciJiLXfeQy0dQ+EG1TgZJkFO\
UhgBQF0Z/njPjUC8MBplYeVHvLeUdSB6iIfHFaRqKjW7cNmmsaCWr6WpUmFGiHj7\
pMbxUye6+pfMf4FQCFZ7X6G8ziwFU0QHlTgz2cRqJT5J7fkCQQD93ZoA3jEz4NCe\
obz2pVhgrbS4Ukh90VyzHEiVi0gk1BmjpoAiwoNXD3zHLoFhEZoQ+TwYY+vHnrsa\
OEEz9VOtAkEAyNUj1sByrFR5y0SKIH+Hz0M6y9Lrp10Vk8g8L6JTB/ZH+CIceN8j\
4hFiW8k5osdEoGBKJxDrSbXOWWMiooON7wJBAOwIDnjCHVMTskPbMvrLjpkMyFsb\
veSlNKAfKulHf4MmZNRAKSCoYz8d2jDC723V1L31TMeMl5qY3XMqXI03il0CQCW+\
kR7CSosC0WUXe5JCBac5bmpyOKHax7xfjJgzPMGpUrtaxdkdruPE+qRffDqQkuBF\
WIphDqdqyN5Z2F+Ms/cCQCglmEm1Vs/4cdiWKtM8BmvvtXSm9xt/9cFsVYfSIJRb\
h9F/WkgiHbkFgR5OJoyZHNENXqzo9WHmWIrtf9IODIE=\
-----END GHRSA PRIVATE KEY-----\
"



#define RONGYUN_KEY_FORM  @"ik1qhw091dt7p"
#define RONGYUN_KEY_TEST  @"3argexb6rnoze"


//#define RONGYUN_KEY_TEST  @"6tnym1brnz657"
/**
 * 环境切换
 */
#if IS_FORMAL

#define ROOT_URL_HOST_FOR_API ROOT_URL_HOST_FOR_API_TEST
#define RSASyg_Public_key RSASyg_Public_key_FORM
#define RSASyg_Private_key RSASyg_Private_key_FORM
#define RONGYUN_KEY  RONGYUN_KEY_FORM

#else

#define ROOT_URL_HOST_FOR_API ROOT_URL_HOST_FOR_API_TEST
#define RSASyg_Public_key RSASyg_Public_key_TEST
#define RONGYUN_KEY  RONGYUN_KEY_TEST

#endif


/******************************************************************************
 *  支付宝 (待更新)
 ******************************************************************************/


//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088021638865061"
//收款支付宝账号
#define SellerID  @"2088021638865061"
#define ALIPAY_SHEME @"aplipay2088021638865061"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKyaWsgjcLjJ8Qpm\
diRMCYp9mGSFiHNoq9yXiYL/8yrANK4N4xThFI4WqMe0kdIDaMdwR/0hvhu1YJ1X\
GTMEToC7xt1kTdJAJGOyygVQ8tiO3I+Qfb+zb0e0+5mdxaA1lcxIEFzluTH3PFqX\
KV3V7Tt0CD4ZE6do+FugQMCxUKGNAgMBAAECgYBIaFRvI1b1XloNF+C152QVQgz9\
FnuglqeKWdPpLcBwDcPLxK2fo7DAzsatSJXnuWBqUjMRAOfErflC6Df9C/B2JnId\
upXObjRh29g5TC2yfxao7mELZ41eDpHVZ8E8cGjzRNaCpGzdYyHZIyHvNatw2eR5\
duV6XcnILoLoG3yEIQJBANKiHc4AHQMTyA0hfQkkGl+69ZSQuROmSgqE7LBffu6o\
XXaWyhaPHswLslEF5bZ3JKGkxwFtkZ3H5VYfQzye1IUCQQDRx1Mq0P13qeSGmpUb\
olIp8X0u8ZAEvfqj5mdpa/BDy5HxbLD12Uf0leE0VZlUzPNvZ5iel0vMNlG65Ex2\
7stpAkAtjf5gNUoRBlA39swyE+rYVXkTnpFInKhayhDevGiZeTRtl4MxidahTs5M\
E7hw1CfKBfc8adQaicch7zT9gWR5AkBa0qeJRA5ZPq74L/kai75y9mCycFdgFjhr\
uZdQJzFQyNQY6Gv9JONoW3OzStQlyM4kj3+eOfbRJTthZPJOE7jxAkEAq2V7c7Qg\
G12RcamxpkdYynMjrINQqgTOz5eAy2zmt/YnXgTMVHh3Z0mbkoh84T/myW3WgB1g\
sxCS5sYlOGdMkQ=="


//支付宝公钥

#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsmlrII3C4yfEKZnYkTAmKfZhk\
hYhzaKvcl4mC//MqwDSuDeMU4RSOFqjHtJHSA2jHcEf9Ib4btWCdVxkzBE6Au8bd\
ZE3SQCRjssoFUPLYjtyPkH2/s29HtPuZncWgNZXMSBBc5bkx9zxalyld1e07dAg+\
GROnaPhboEDAsVChjQIDAQAB"


#define WX_APP_ID @"wx75b647e1aed598a6"
#define WX_APP_SECRET @"dbe1054539615546f17700803596c1ee"



// 支付宝（noify）
#define ALIPAY_NOTIFY_URL @"http://c.mklmall.com/o2o-consumer/alipayForApp/alipayNotifyForApp.htm"






//友盟key
#define UM_KEY_App @"55ac5bff67e58e1cff00706f"
//AppStore 下载地址
#define APPSTORE_LOAD_URL @"https://itunes.apple.com/cn/app/she-yi-gou/id1007077225?l=en&mt=8"
//登录
#define SHEYIGOU_API_LOGIN_ACTION @"login"
//邀请码获取
#define SHEYIGOU_API_ADDINVITATIONCODE_ACTION @"addinvitationcode"

//首页急求/急售列表
#define SHEYIGOU_API_GETGOODSLIST_ACTION @"getgoodslist"

//获取手机号
#define SHEYIGOU_API_GETPHONECODE_ACTION @"getphonecode"

//获取国家代码
#define SHEYIGOU_API_GETCOUNTRYCODE_ACTION  @"getcountrycode"

//验证手机号
#define SHEYIGOU_API_VERIFYCODE_ACTION  @"verifycode"

//验证用户是否已被注册
#define SHEYIGOU_API_CHECKUSEREXISTS_ACTION   @"checkuserexists"

//用户注册
#define SHEYIGOU_API_USERREG_ACTION @"userreg"

//验证邀请码
#define SHEYIGOU_API_GETINVITATIONCODE_ACTION @"getinvitationcode"

//免密码登陆
#define SHEYIGOU_API_CODELOGIN_ACTION @"codelogin"

//设置新密码/忘记密码
#define SHEYIGOU_API_UPDATEPASSWORD_ACTION @"updatepassword"

//正在闪购的商品列表
#define SHEYIGOU_API_GETFLASHBUY_ACTION @"getflashbuy"

//用户信息
#define SHEYIGOU_API_USERINFO_ACTION @"userinfo"

//推送所需要的devicetoken
#define SHEYIGOU_API_GETDEVICETOKEN_ACTION    @"getdevicetoken"

//获取聊天token
#define SHEYIGOU_API_RYGETTOKEN_ACTION @"rygettoken"

//报名闪购
#define SHEYIGOU_API_CREATEFLASHBUY_ACTION @"createflashbuy"

//闪购具体信息
#define SHEYIGOU_API_VIEWFLASHBUY_ACTION @"viewflashbuy"

//查看一个急求/急售商品的信息
#define SHEYIGOU_API_VIEWGOODS_ACTION @"viewgoods"

//获取货源商品广告位列表
#define SHEYIGOU_API_GETCATALOGLIST_ACTION @"getcataloglist"

//卖家对闪购商品进行发货动作
#define SHEYIGOU_API_SENDFLASHBUY_ACTION @"sendflashbuy"


//删除一个急求/急售商品的信息
#define SHEYIGOU_API_DELGOODS_ACTION @"delgoods"

//下架一个急求/急售商品的信息
#define SHEYIGOU_API_GOODSOFF_ACTION @"goodsoff"


//上架一个急求/急售商品的信息
#define SHEYIGOU_API_GOODSON_ACTION @"goodson"


//首页banner
#define SHEYIGOU_API_HOMEPAGEBANNER_ACTION @"homepagebanner"

//修改手机号
#define SHEYIGOU_API_EDITPHONE_ACTION @"editphone"

//增加到收藏
#define SHEYIGOU_API_ADDCOLLECT_ACTION @"addcollect"

//上传图片
#define SHEYIGOU_API_IMGUPLOAD_ACTION @"imgupload"

//修改用户简介
#define SHEYIGOU_API_EDITSYNOPSIS_ACTION @"editsynopsis"

//圈子列表
#define SHEYIGOU_API_SHOPSLIST_ACTION @"shopslist"

//获取好友列表
#define SHEYIGOU_API_USERFRIENDLIST_ACTION @"userfriendlist"

//删除好友列表
#define SHEYIGOU_API_DELFRIEND_ACTION @"delfriend"

//闪购订单确认购买
#define SHEYIGOU_API_READYFLASHBUY_ACTION @"readyflashbuy"

//闪购订单获取库存量
#define SHEYIGOU_API_GETGOODSINVENTORY_ACTION @"getgoodsinventory"

//获取用户收货地址
#define SHEYIGOU_API_GETADDRESS_ACTION @"getaddress"

//添加用户收货地址
#define SHEYIGOU_API_ADDADDRESS_ACTION @"addaddress"

//修改用户收货地址
#define SHEYIGOU_API_EDITADDRESS_ACTION @"editaddress"

//删除用户收货地址
#define SHEYIGOU_API_DELADDRESS_ACTION @"deladdress"

//我的闪购订单
#define SHEYIGOU_API_MYFLASHBUY_ACTION @"myflashbuy"

//修改闪购订单有效时长
#define SHEYIGOU_API_SETLOCKLIMIT_ACTION @"setlocklimit"

//确认收货
#define SHEYIGOU_API_CONFIRMGOODS_ACTION @"confirmgoods"

//城市地区
#define SHEYIGOU_API_GETAREA_ACTION @"area"

//好友验证列表
#define SHEYIGOU_API_ADDFRIEDNLIST_ACTION @"addfriendlist"

//同意/拒绝添加好友
#define SHEYIGOU_API_AUTHFRIEND_ACTION @"authfriend"

//添加好友
#define SHEYIGOU_API_ADDFRIEND_ACTION @"addfriend"

//判断是否我的好友
#define SHEYIGOU_API_JUDGEFRIEND_ACTION @"judgefriend"

//准备充值
#define SHEYIGOU_API_READYPAYING_ACTION @"readypaying"

//准备支付
#define SHEYIGOU_API_READYPAY_ACTION @"readypay"

//修改淘宝号
#define SHEYIGOU_API_EDITMALL_ACTION @"editmall"

//修改微信号
#define SHEYIGOU_API_EDITWX_ACTION @"editwx"

//修改用户头像
#define SHEYIGOU_API_EDITSIMAGE_ACTION @"editsimage"

//返回用户认证状态
#define SHEYIGOU_API_USERAUTO_ACTION @"userauth"

//发送消息给奢易购小秘书
#define SHEYIGOU_API_CALLSECRETARY_ACTION @"callsecretary"

//修改用户信息
#define SHEYIGOU_API_EDITUSERINFO_ACTON @"edituserinfo"

//修改用户名
#define SHEYIGOU_API_EDITSHOPNAME_ACTION @"editshopname"

//搜索急求/急售商品
#define SHEYIGOU_API_SEARCHGOODS_ACTION @"searchgoods"

//搜索热词及热门商品获取
#define SHEYIGOU_API_GETHOT_ACTION @"gethot"

//查看单个库存商品
#define SHEYIGOU_API_VIEWMYGOODS_ACTION @"viewmygoods"

//查看库存商品列表
#define SHEYIGOU_API_VIEWMYGOODSLIST_ACTION @"viewmygoodslist"

//查询交易明细
#define SHEYIGOU_API_GETACCOUNT_ACTION @"getaccount"

//获取销售报表
#define SHEYIGOU_API_TOTALSALES_ACTION  @"total_sales"

//微信提现
#define SHEYIGOU_API_WECHATCASHAPPLY_ACTION @"wechatcashapply"

//提现申请
#define SHEYIGOU_API_CASHAPPLY_ACTION @"cashapply"

//添加银行卡
#define SHEYIGOU_API_ADDCARD_ACTION @"addcard"



//获取收藏列表
#define SHEYIGOU_API_GETCOLLECT_ACTION @"getcollect"

//删除收藏列表
#define SHEYIGOU_API_DELCOLLECT_ACTION @"delcollect"

//获取银行卡
#define SHEYIGOU_API_GETCARD_ACTION @"getcard"

//删除银行卡
#define SHEYIGOU_API_DELCARD_ACTION @"delcard"

//获取广告位对应商品列表
#define SHEYIGOU_API_GETCATALOGGOODSLIST_ACTION @"getcataloggoodslist"


//实名制认证
#define SHEYIGOU_API_NAMEAUTH_ACTION @"nameauth"

//实体店认证
#define SHEYIGOU_API_SHOPAUTH_ACTION @"shopauth"

//添加我要出货/我要求货（急求/急售）
#define SHEYIGOU_API_ADDGOODS_ACTION @"addgoods"

//编辑我要出货/我要求货（急求/急售）
#define SHEYIGOU_API_EDITGOODS_ACTION @"editgoods"

//好友验证条数
#define SHEYIGOU_API_GETFRIENDNUMBER_ACTION @"getfriendnumber"


/****  售出商品相关   *****/
//添加出售商品
#define SHEYIGOU_API_ADDSOLDRECORD_ACTION @"addsoldrecord"

//编辑出售商品
#define SHEYIGOU_API_MODIFYSOLDRECORD_ACTION @"modifysoldrecord"

///查看售出商品列表
#define SHEYIGOU_API_GETSOLDRECORDLIST_ACTION @"getsoldrecordlist"

///删除售出商品
#define SHEYIGOU_API_DELETESOLDRECORD_ACTION @"deletesoldrecord"

//【链接】奢易购服务协议
#define SHEYIGOU_H5_AGREEMENT @"http://www.sheyigou.com/agreement/index.html"


#endif /* HXAppMacro */
