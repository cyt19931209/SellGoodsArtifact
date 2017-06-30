//
//  MD5CommonDigest.m
//  奢易购3.0
//
//  Created by Andy on 2016/11/14.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "MD5CommonDigest.h"

@implementation MD5CommonDigest




+(void)MD5:(NSString *)passwordStr
   success:(void (^)(id result))successBlock
   failure:(void (^)(NSError *error))failBlock{

    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    

    
    [DataSeviece requestUrl:get_userinfohtml params:params success:^(id result) {
        
        NSLog(@"%@ %@",result,result[@"result"]);

        NSLog(@"%@ %@",result[@"result"][@"data"][@"randstr"],passwordStr);
        
        
        
//        NSString *str1 = [self md5HexDigest:[NSString stringWithFormat:@"%@",result[@"result"][@"data"][@"randstr"]]];
//        
        const char *cStr = [result[@"result"][@"data"][@"randstr"] UTF8String];
        unsigned char result1[16];
        CC_MD5(cStr, strlen(cStr), result1); // This is the md5 call
        NSString *str1 =  [NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          result1[0], result1[1], result1[2], result1[3],
                          result1[4], result1[5], result1[6], result1[7],
                          result1[8], result1[9], result1[10], result1[11],
                          result1[12], result1[13], result1[14], result1[15]
                          ];

        const char *cStr2 = [passwordStr UTF8String];
        unsigned char result2[16];
        CC_MD5(cStr2, strlen(cStr2), result2); // This is the md5 call
        NSString *str2 =  [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result2[0], result2[1], result2[2], result2[3],
                           result2[4], result2[5], result2[6], result2[7],
                           result2[8], result2[9], result2[10], result2[11],
                           result2[12], result2[13], result2[14], result2[15]
                           ];

        
        
        
//        NSString *str2 = [self md5HexDigest:passwordStr];
        
        
        NSLog(@"%@ %@",str1,str2);
        
        
        const char *cStr3 = [[NSString stringWithFormat:@"%@%@",str1,str2] UTF8String];
        unsigned char result3[16];
        CC_MD5(cStr3, strlen(cStr3), result3); // This is the md5 call
        NSString *str3 =  [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result3[0], result3[1], result3[2], result3[3],
                           result3[4], result3[5], result3[6], result3[7],
                           result3[8], result3[9], result3[10], result3[11],
                           result3[12], result3[13], result3[14], result3[15]
                           ];

        NSLog(@"%@",str3);
        
        if ([str3 isEqualToString:result[@"result"][@"data"][@"password"]]) {
            successBlock(@"1");
        }else{
            successBlock(@"0");
        }
        
        

    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
        
    }];

    
    

}

- (NSString*)md5HexDigest:(NSString*)input{

    const char *cStr = [input UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];

}







@end
