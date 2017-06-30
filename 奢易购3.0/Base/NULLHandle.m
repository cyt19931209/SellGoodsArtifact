//
//  NULLHandle.m
//  RMXJY
//
//  Created by MacBooK on 16/3/7.
//  Copyright © 2016年 MacBooK. All rights reserved.
//

#import "NULLHandle.h"

@implementation NULLHandle


+(NSDictionary*)NUllHandle:(id)result{
   
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:result];
    NSArray *allKeysArr = [mutableDic allKeys];

    for (NSString *key in allKeysArr) {
        if ([mutableDic[key] isKindOfClass:[NSNull class]]) {
        
            [mutableDic setValue:@"" forKey:key];
        }
    }
    
    return mutableDic;
}



@end
