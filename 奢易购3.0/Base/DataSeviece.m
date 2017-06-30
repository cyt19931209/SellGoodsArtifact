//
//  DataSeviece.m
//  RMXJY
//
//  Created by MacBooK on 16/3/4.
//  Copyright © 2016年 MacBooK. All rights reserved.
//

#import "DataSeviece.h"
#import "AFNetworking.h"
#define BaseUrl @"http://192.168.1.172:8090/rmjysit" 
//#define BaseUrl @"http://111.113.28.26:8910/rmjysit"
//#define BaseUrl @"http://192.168.1.184:8080/rmjysit"

@implementation DataSeviece


+(void)requestUrl:(NSString *)url
           params:(NSMutableDictionary *)param
          success:(void (^)(id result))successBlock
          failure:(void (^)(NSError *error))failBlock{

    //1.拼接url
    url = [BaseUrl stringByAppendingString:url];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"%@\n %@",url,param);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        successBlock(responseObject);
        [hud hide:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failBlock(error);
        [hud hide:YES];
    }];
    
}


@end
