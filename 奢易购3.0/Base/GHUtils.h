//
//  GHUtils.h
//  MACALLINE
//
//  Created by Hank on 15/12/26.
//  Copyright © 2015年 NSLOG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSA.h"

@interface GHUtils : NSObject
+(NSString*)dictionaryToJson:(NSDictionary*)dic;


+(NSString*)rasEnString:(NSString*)noEnStr;
+(NSString*)decryWithString:(NSString *)string;

@end
