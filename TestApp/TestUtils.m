//
//  TestUtils.m
//  TestApp
//
//  Created by Ankur Gupta on 14/09/2014.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "TestUtils.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>




@implementation TestUtils




+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return hash;
}


+(NSString *)testHMACSHA1 :(NSData *) data key:(NSData *) key
{
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    const char *cKey  =(__bridge const void *)(key);
    const char *cData =(__bridge const void *)(data);
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return hash;
    
}

// convert nsstring to MD5
+ (NSString *) convertTOMD5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+ (NSString*)convertNSdataToMD5 :(NSData *) input
{
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(input.bytes, input.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

+ (NSString *)GetCurrentTimeStamp
{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString    *strTime = [objDateformat stringFromDate:[NSDate date]];
    NSString    *strUTCTime = [self GetUTCDateTimeFromLocalTime:strTime];//You can pass your date but be carefull about your date format of NSDateFormatter.
    NSDate *objUTCDate  = [objDateformat dateFromString:strUTCTime];
    long long milliseconds = (long long)[objUTCDate timeIntervalSince1970];
    
    NSString *strTimeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
    NSLog(@"The Timestamp is = %@",strTimeStamp);
    
    return strTimeStamp;
}

+ (NSString *) GetUTCDateTimeFromLocalTime:(NSString *)IN_strLocalTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  *objDate    = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    return strDateTime;
}


+(NSMutableArray *)parseJSONResponse:(NSDictionary *) dic
{
    NSMutableArray *finalTweetsArray = [[NSMutableArray alloc]init];

    NSArray *array =dic[@"statuses"];
    for (NSMutableDictionary *dictionary in array)
    {
        TweetInfo *tweet = [[TweetInfo alloc]init];
        tweet.tweetText = dictionary[@"text"];
        tweet.createdAtTime = dictionary [@"created_at"];
        tweet.userName = dictionary[@"user"][@"screen_name"];
        tweet.hashTag = [(NSArray *)dictionary [@"entities"] [@"hashtags"] count]>0 ?[(NSArray *)dictionary [@"entities"] [@"hashtags"] firstObject] : @"";
        tweet.emotionImg = @"happy";
        [finalTweetsArray addObject:tweet];
    }
 
    return finalTweetsArray;
}
+(NSString *)getUniqueIDForName:(NSString *) name
{
    NSInteger storedVal = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UNIQUE_IDENTIFIER"] integerValue];
    if(storedVal == 0)
    [[NSUserDefaults standardUserDefaults]setValue:@"123" forKey:@"UNIQUE_IDENTIFIER"];
    
    NSInteger temp= storedVal>0?storedVal:123;
    
    NSString *uniqueString= [NSString stringWithFormat:@"%ld%@%ld",temp,name,temp];
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",temp+1] forKey:@"UNIQUE_IDENTIFIER"];

    return uniqueString;
}

@end
