//
//  ResultViewController.m
//  TestApp
//
//  Created by Ankur Gupta on 14/09/2014.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "ResultViewController.h"
#import "DataCell.h"
#import "TweetInfo.h"
@implementation ResultViewController

#define CELL_DEFAULT_HEIGHT 100
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doneBtnAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweetDataArray count];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    long height;
     TweetInfo *tweetDetail=[self.tweetDataArray objectAtIndex:indexPath.row];
    height =  [[tweetDetail tweetText] length]*2;
    return height > CELL_DEFAULT_HEIGHT ? height : CELL_DEFAULT_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DataCell *cell = [resultTableView dequeueReusableCellWithIdentifier:@"DataCell"];
    
    if (!cell) {
        cell = [[DataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DataCell"];
    }
    TweetInfo *tweetDetail=[self.tweetDataArray objectAtIndex:indexPath.row];
    cell.tweetTextView.frame =CGRectMake(8, 8,220, [[tweetDetail tweetText] length]*2 > CELL_DEFAULT_HEIGHT ? [[tweetDetail tweetText] length]*2 : CELL_DEFAULT_HEIGHT);
    NSString *tempString =[NSString stringWithFormat:@"@%@ \n %@ \n created at %@",tweetDetail.userName,tweetDetail.tweetText,tweetDetail.createdAtTime];
    cell.tweetTextView.text= tempString;
    cell.emotionImageView.image = [UIImage imageNamed:tweetDetail.emotionImg];
    
    return cell;
}


@end
