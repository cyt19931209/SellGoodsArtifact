//
//  GHUtils.m
//  MACALLINE
//
//  Created by Hank on 15/12/26.
//  Copyright © 2015年 NSLOG. All rights reserved.
//

#import "GHUtils.h"
#import "HXAppMacro.h"
#import "GHRSA.h"


@implementation GHUtils
+(NSString*)dictionaryToJson:(NSDictionary*)dic
{

    if (!validateDictionary(dic)) return nil;
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    
    return nil;
}


static BOOL validateDictionary(NSDictionary *dictionary)
{
    BOOL result = NO;
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
        result = YES;
    }
    return result;
};

+(NSString *)rasEnString:(NSString *)noEnStr
{
   return  [GHRSA encryptString:noEnStr publicKey:RSASyg_Public_key];
}

+(NSString *)decryWithString:(NSString *)string
{
    return [GHRSA decryptString:string privateKey:RSASyg_Private_key];
}

@end
