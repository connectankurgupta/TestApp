//
//  ViewController.m
//  TestApp
//
//  Created by Ankur Gupta on 14/09/2014.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TestUtils.h"
#import "ResultViewController.h"
@interface ViewController ()


@end

@implementation ViewController
#define APIKey  @"31760cea-e478-426f-80ab-17adb0696238" // private for me
#define APISecret  @"fa512594-591e-4ec0-b659-c5bae5842c59" // private for me

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    submitBtn.backgroundColor =[UIColor grayColor];
    submitBtn.layer.cornerRadius =5.0;
    submitBtn.clipsToBounds = YES;
    [activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submitBtnAction:(id)sender
{
    if (inputField.text.length>0) {
        [inputField resignFirstResponder];
        [self getDataFromTwitter];
        [activityIndicator setHidden:NO];
        [activityIndicator startAnimating];
    }
    else{
    
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter tweet to search" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    
    }
    

}

// Call Twitter api for search request
- (void)getDataFromTwitter {
    
    // 1. set an URL
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    
    // 2. set NSMutableArray For Parameter
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:inputField.text forKey:@"q"];
    [parameter setObject:@"3" forKey:@"count"];
    [parameter setObject:@"popular" forKey:@"result_type"];
    
    //3. set ACAccountStore & ACAccountType
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (granted == YES) {
            NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountArray count] > 0) {
                
                ACAccount *twitterAccount = [accountArray lastObject];
                
                // guna slrequest to get data from twitter
                
                SLRequest *getRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:parameter];
                
                
                // set twitter account
                [getRequest setAccount:twitterAccount];
                
                [getRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    NSString *output = [NSString stringWithFormat:@"HTTP response status %li : ", (long)[urlResponse statusCode]];
                    NSLog(@"Output : %@", output);
                    NSDictionary *dic = nil;
                    if(responseData.length >0 )
                     dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];

                    if (dic!= nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //[self.tableView reloadData];
                            NSLog(@"search result: %@", self.results);
                            inputField.text = @"";
                            [activityIndicator stopAnimating];
                           self.finalTweetArray = [TestUtils parseJSONResponse:dic];
                            [self setUPRequestForSemantria];
                            [self loadResultView];
                        });
                    }
                    
                }];
                
            }
            else{
                [activityIndicator stopAnimating];
                UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"Authentication Failed" message:@"Please login to twitter account in settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            
            }
        }
        
    }];
}

// Function to load Resultview
-(void)loadResultView
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ResultViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ResultViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.tweetDataArray= self.finalTweetArray;
    [self presentViewController:vc animated:YES completion:NULL];


}

// Function to set up header and url for authentication for semantri api
-(void)setUPRequestForSemantria
{
    NSString *consumerKey =@"31760cea-e478-426f-80ab-17adb0696238"; // public key
    NSString *oAuthNounce =@"8e9a56a4c2cf47f"; // random 64 bit ascii decimal string
    NSString *timeStamp = [TestUtils GetCurrentTimeStamp];
    //[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSString *signateureBaseString = [NSString stringWithFormat:@"https://api35.semantria.com/document.json?oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%@&oauth_version=1.0",consumerKey,oAuthNounce,timeStamp];
    NSData *signatureBaseStringInByte =[signateureBaseString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secretKeyInByte = [[TestUtils convertTOMD5:APISecret] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *hmacSHA1String = [TestUtils testHMACSHA1:signatureBaseStringInByte key:secretKeyInByte];
    NSString *finalString = [[hmacSHA1String dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"final string %@",finalString);
    NSLog(@"signatue base string %@",signateureBaseString);
    [self callAuthenctication:[NSURL URLWithString:signateureBaseString]];


}

// Function to call authentication for sementria api
/*
 Authentication Algorithm
 
 Obtain User Key and Secret (we emailed it to you when you registered with Semantria. Check your junk folder if you can't find it!)
 Generate signature base string (with URL)
 Generate OAuth signature for URL
 Encode signature base string with UTF-8 encoding. Keep encoded symbols in upper case.
 Calculate MD5 using secret key and use it in lower case.
 Convert signature base string and MD5 hash code of the secret into byte representations.
 Encrypt bytes of signature base string with MD5 hash code using HMAC-SHA1 algorithm.
 Convert result back into string form using Base64 algorithm and UTF-8 encoding.
 Encode string with URL encoding algorithm and write as oauth_signature parameter.
 Create Authorization Header as shown below. Note the single Authorization HTTP header with parameters separated by commas.
 Combine URL and header into the request and use it for authorization for the Semantria API.
 
 */
-(void)callAuthenctication:(NSURL *) url
{
    NSLog(@"URL to call %@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml"
   forHTTPHeaderField:@"Content-type"];
    
    
    //    NSString *sendString = [NSString stringWithFormat:@"Authorization: OAuth realm='',oauth_consumer_key='XXXXX',                            oauth_nonce='3931596951957366614',oauth_signature='',oauth_signature_method='HMAC-SHA1',oauth_timestamp='1320143435',oauth_version='1.0'"];
    
    NSString *sendString = [NSString stringWithFormat:@"OAuth,oauth_consumer_key='XXXXX',                            oauth_nonce='3931596951957366614',oauth_signature='',oauth_signature_method='HMAC-SHA1',oauth_timestamp='1320143435',oauth_version='1.0'"];
    
    [request setValue:sendString forHTTPHeaderField:@"Authorization"];

    // create body string to send tweet details
    //{"id": str(uuid.uuid4()).replace("-", ""), "text": text}
    
    NSMutableString *tempBodyString = [NSMutableString stringWithString:@"{"];
    for (int count= 0; count < [self.finalTweetArray count]; count++) {
        if(count!=0)
        [tempBodyString appendString:@","];
        
        TweetInfo * tweetDetail = (TweetInfo *)[self.finalTweetArray objectAtIndex:count];
        [tempBodyString appendString:[NSString stringWithFormat:@"{'id':%@, 'text':%@ }",[TestUtils getUniqueIDForName:tweetDetail.userName], tweetDetail.tweetText]];
    }
      [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[tempBodyString length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[tempBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.connection start];
    
}


#pragma mark Connection delegates
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error %@",error);
}
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    self.buffer = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    NSLog(@" buffer %@",[[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding]);
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:self.buffer options:0 error:&jsonParsingError];
    self.results = [jsonResults objectForKey:@"results"];
    
    self.buffer = nil;
    
    NSLog(@"result ------>>>> %@",self.results);

}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}



@end
