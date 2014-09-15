//
//  DataCell.h
//  TestApp
//
//  Created by Ankur Gupta on 14/09/2014.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UITextView *tweetTextView;
@property (nonatomic,retain) IBOutlet UIImageView *emotionImageView;
@end
