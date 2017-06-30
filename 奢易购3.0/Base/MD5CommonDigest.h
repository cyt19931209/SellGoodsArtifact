//
//  MD5CommonDigest.h
//  奢易购3.0
//
//  Created by Andy on 2016/11/14.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface MD5CommonDigest : NSObject


+(void)MD5:(NSString *)md5Str
          success:(void (^)(id result))successBlock
          failure:(void (^)(NSError *error))failBlock;




@end
