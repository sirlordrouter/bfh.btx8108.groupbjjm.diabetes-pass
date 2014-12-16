//
//  DiaryViewController.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 16.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "DiaryViewController.h"
#import "OAuth1Controller.h"
#import "ch_bfh_bti8108_groupbjjmAppDelegate.h"
#import "SettingsWithingsViewController.h"

@interface DiaryViewController()

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;

@end

@implementation DiaryViewController

-(void)viewDidLoad {
    
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    SettingsWithingsViewController *withings = delegate.withingsController;
    self.oauthToken = withings.oauthToken;
    self.oauthTokenSecret = withings.oauthTokenSecret;
    userId = @"4899465";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getWithingsData)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
        

    }
}

-(void)getWithingsData {
    //    meastype
    //    1 : Weight (kg)
    //    9 : Diastolic Blood Pressure (mmHg)
    //    10 : Systolic Blood Pressure (mmHg)
    //    11 : Heart Pulse (bpm)
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getmeas" forKey:@"action"];
    [dict setObject:userId forKey:@"userid"];
    //[dict setObject:@"1" forKey:@"meastype"];
    [dict setObject:@"1" forKey:@"category"]; //get measurements not user objectives
    NSLog(@"self.oauthToken=%@,self.oauthTokenSecret=%@",self.oauthToken,self.oauthTokenSecret);
    NSURLRequest *request =
    [OAuth1Controller preparedRequestForPath:@"measure"
                                  parameters:dict
                                  HTTPmethod:@"GET"
                                  oauthToken:self.oauthToken
                                 oauthSecret:self.oauthTokenSecret];
    
    NSLog(@"RRRRR %@",request.URL);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             ////
             //            NSLog(@"HHHHHH %@===",greeting);
             ////
             ////             for (id key in greeting) {
             ////                 NSLog(@"key: %@, value: %@", key, [greeting objectForKey:key]);
             ////
             ////             }
             
             
             
             NSDictionary *body = [greeting objectForKey:@"body"];
             NSDictionary *measureGroups = [body objectForKey:@"measuregrps"];
             
             for (NSDictionary *nsdict in measureGroups) {
                 
                 NSDictionary *measures = [nsdict objectForKey:@"measures"];
                 
                 for (NSDictionary *ms in measures) {
                     
                     NSLog(@"Datum: %@", [nsdict objectForKey:@"date"]);
                     //                     for (id key in ms) {
                     //                         NSLog(@"key: %@, value: %@", key, [ms objectForKey:key]);
                     //
                     //                     }
                     
                     if ([[ms objectForKey:@"type"]integerValue] == 1) {
                         NSLog(@"Gewicht (kg): %@", [ms objectForKey:@"value"]);
                     }
                     if ([[ms objectForKey:@"type"] integerValue] == 9) {
                         NSLog(@"BD dia (mmHg): %@", [ms objectForKey:@"value"]);
                     }
                     if ([[ms objectForKey:@"type"] integerValue] == 10) {
                         NSLog(@"BD sys (mmHg): %@", [ms objectForKey:@"value"]);
                     }
                     if ([[ms objectForKey:@"type"] integerValue] == 11) {
                         NSLog(@"Puls (bpm): %@", [ms objectForKey:@"value"]);
                     }
                 }
             }
             
         }
     }];
    
    [self reloadData];

}

- (OAuth1Controller *)oauth1Controller
{
    if (_oauth1Controller == nil) {
        _oauth1Controller = [[OAuth1Controller alloc] init];
    }
    return _oauth1Controller;
}

@end
