//
//  HXPayResult.m
//  HX_SHOP
//
//  Created by hzh on 15/3/18.
//  Copyright (c) 2015年 TES. All rights reserved.
//

#import "HXPayResult.h"
#import "DataVerifier.h"

@implementation HXPayResult

- (instancetype)initWithType:(PaymentType)type responce:(id)responce{
    self = [super init];
    if (self) {
        _type = type;
        _responce = [responce copy];
    }
    return self;
}

+ (NSDictionary*)parseAliResult:(NSString*)result{
    if (!result) {
        return nil;
    }
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    NSArray *arr = [result componentsSeparatedByString:@"&"];
    for (NSString *arrStr in arr)
    {
        NSInteger idx = [arrStr rangeOfString:@"="].location;
        NSString *key = [arrStr substringWithRange:NSMakeRange(0, idx)];
        NSString *value = [arrStr substringWithRange:NSMakeRange(idx+2, arrStr.length - idx - 3)];
        [mDic setObject:value forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:mDic];
}


+ (BOOL)verifyAliResult:(NSString*)result publicKey:(NSString*)publicKey{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[result componentsSeparatedByString:@"&"]];
    NSString *sign = nil;
    for (int i = (int)arr.count - 1; i > -1; i--)   // 倒序删除
    {
        NSString *arrStr = arr[i];
        if ([arrStr hasPrefix:@"sign="]) {
            [arr removeObjectAtIndex:i];
            sign = [arrStr substringWithRange:NSMakeRange(6, arrStr.length - 7)];
        }
        else if([arrStr hasPrefix:@"sign_type="]) {
            [arr removeObjectAtIndex:i];
        }
    }
    NSString *toVerifyString = [arr componentsJoinedByString:@"&"];
    // 验证
    id<DataVerifier> dataVerifier = CreateRSADataVerifier(publicKey);
    return [dataVerifier verifyString:toVerifyString withSign:sign];
}


@end
