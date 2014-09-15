//
//  TweetInfo.m
//  TestApp
//
//  Created by Ankur Gupta on 14/09/2014.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "TweetInfo.h"

@implementation TweetInfo

-(id) init
{
    if ( (self = [super init]) )
    {
        self.createdAtTime = @"";
        self.userName = @"";
        self.tweetText = @"";
        self.hashTag = @"";
        self.emotionImg = @"";
    }
    
    return self;
}

@end
