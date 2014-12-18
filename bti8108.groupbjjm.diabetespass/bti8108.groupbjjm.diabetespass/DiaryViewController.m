//
//  DiaryViewController.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 16.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//
// Credits: http://www.appcoda.com/pull-to-refresh-uitableview-empty/
// Implementing Pull-to-Refresh Tutorial to get Data when sliding down

#import "DiaryViewController.h"
#import "OAuth1Controller.h"
#import "ch_bfh_bti8108_groupbjjmAppDelegate.h"
#import "SettingsWithingsViewController.h"
#import "DiaryTableCell.h"
#import "DiaryEntry.h"

@interface DiaryViewController()

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;

@end

@implementation DiaryViewController

-(void)viewDidLoad {
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    
    self.diaryData = [[NSMutableArray alloc] init];
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

             NSDictionary *body = [greeting objectForKey:@"body"];
             NSDictionary *measureGroups = [body objectForKey:@"measuregrps"];
             
             for (NSDictionary *nsdict in measureGroups) {
                 
                 NSDictionary *measures = [nsdict objectForKey:@"measures"];
                 
                 for (NSDictionary *ms in measures) {
                     
                     DiaryEntry *newEntry = [[DiaryEntry alloc] init];
                     
                     newEntry.date =  [self getDateStringForUnit:[nsdict objectForKey:@"date"]];
                     
                     
                     if ([[ms objectForKey:@"type"]integerValue] == 1) {
                         newEntry.value = [NSString stringWithFormat:@"%ld",[[ms objectForKey:@"value"] integerValue]  / 100 ];
                         newEntry.unit = @"kg";
                     }
                     if ([[ms objectForKey:@"type"] integerValue] == 9) {
                         newEntry.value = [ms objectForKey:@"value"];
                         newEntry.unit = @"mmHg";
                     }
                     if ([[ms objectForKey:@"type"] integerValue] == 10) {
                         newEntry.value = [ms objectForKey:@"value"];
                         newEntry.unit = @"mmHg";
                     }
                     if ([[ms objectForKey:@"type"] integerValue] == 11) {
                         newEntry.value = [ms objectForKey:@"value"];
                         newEntry.unit = @"bpm";
                     }
                     
                     if (![self.diaryData containsObject:newEntry]) {
                         [self.diaryData addObject:newEntry];
                     }
                     
                     
                     
                 }
             }
             
         }
     }];
    
    [self reloadData];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *valueCellIdentifier = @"DiaryTableCell";
    DiaryTableCell *cell = (DiaryTableCell *)[self.tableView dequeueReusableCellWithIdentifier:valueCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DiaryTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    UITableViewCell *cell = [tableView
//                             dequeueReusableCellWithIdentifier:@"DiaryCell" forIndexPath:indexPath];

    
    DiaryEntry *currentEntry = [self.diaryData objectAtIndex:indexPath.row];
    
    cell.dateLabel.text = currentEntry.date;
    cell.valueLabel.text = currentEntry.value;
    cell.unitLabel.text = currentEntry.unit;
    
//    cell.textLabel.text = [self.diaryData objectAtIndex:indexPath.row];
//    cell.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];

    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [self.diaryData count];
}

-(NSString *) getDateStringForUnit:(NSString*)datestring {
    double unixTimeStamp =[datestring doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [formatter stringFromDate:date];
}

- (OAuth1Controller *)oauth1Controller
{
    if (_oauth1Controller == nil) {
        _oauth1Controller = [[OAuth1Controller alloc] init];
    }
    return _oauth1Controller;
}

@end
