//
//  HXPayResult.h
//  HX_SHOP
//
//  Created by hzh on 15/3/18.
//  Copyright (c) 2015年 TES. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, AlipayResultCode) {
    AlipayResultCodeSuccess = 9000, //订单支付成功
    AlipayResultCodeDoing = 8000,   //正在处理中
    AlipayResultCodeFail = 4000,    //订单支付失败
    AlipayResultCodeCancel = 6001,  //用户中途取消
    AlipayResultCodeNetErr = 6002   //网络连接出错
};


typedef NS_ENUM(NSUInteger, PaymentType) {
    PaymentTypeAli
};

@interface HXPayResult : NSObject
@property(nonatomic, assign, readonly) PaymentType type;
@property(nonatomic, copy, readonly) id responce;

- (instancetype)initWithType:(PaymentType)type responce:(id)responce;
/// 解析api回调结果
+ (NSDictionary*)parseAliResult:(NSString*)result;
/// 验证api回调
+ (BOOL)verifyAliResult:(NSString*)result publicKey:(NSString*)publicKey;
@end
