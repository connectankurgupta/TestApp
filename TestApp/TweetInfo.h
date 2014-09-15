//
//  TweetInfo.h
//  TestApp
//
//  Created by Ankur Gupta on 14/09/2014.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetInfo : NSObject

@property (nonatomic,retain) NSString *createdAtTime;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *tweetText;
@property (nonatomic,retain) NSString *hashTag;
@property (nonatomic,retain) NSString *emotionImg;
@end
