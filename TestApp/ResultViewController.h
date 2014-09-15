//
//  ResultViewController.h
//  TestApp
//
//  Created by Ankur Gupta on 14/09/2014.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *resultTableView;

}
@property (nonatomic,retain) NSArray *tweetDataArray;
-(IBAction)doneBtnAction:(id)sender;
@end
