//
//  DataSeviece.h
//  RMXJY
//
//  Created by MacBooK on 16/3/4.
//  Copyright © 2016年 MacBooK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSeviece : NSObject



+(void)requestUrl:(NSString *)url
           params:(NSMutableDictionary *)param
          success:(void (^)(id result))successBlock
          failure:(void (^)(NSError *error))failBlock;

@end
