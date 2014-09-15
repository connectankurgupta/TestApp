//
//  ViewController.h
//  TestApp
//
//  Created by Ankur Gupta on 14/09/2014.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{

    IBOutlet UILabel *titleLabel;
    IBOutlet UITextField *inputField;
    IBOutlet UIButton *submitBtn;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    

}
@property (nonatomic,retain) NSArray *results;

@property (nonatomic) NSMutableData  *buffer;
@property (nonatomic) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableArray *finalTweetArray;


-(IBAction)submitBtnAction:(id)sender;

@end

