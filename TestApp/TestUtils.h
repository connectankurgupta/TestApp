//
//  TestUtils.h
//  TestApp
//
//  Created by Ankur Gupta on 14/09/2014.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetInfo.h"

@interface TestUtils : NSObject


+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;
+(NSString *)testHMACSHA1 :(NSData *) data key:(NSData *) key;
+(NSString *) convertTOMD5:(NSString *) input;
+ (NSString*)convertNSdataToMD5 :(NSData *) input;
+ (NSString *)GetCurrentTimeStamp;
+(NSMutableArray *)parseJSONResponse:(NSDictionary *) dic;
+(NSString *)getUniqueIDForName:(NSString *) name;
@end
