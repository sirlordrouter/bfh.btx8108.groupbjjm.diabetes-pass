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
#import "TagebucheintraegePageViewController.h"
#import "DBManager.h"

@interface DiaryViewController()

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) SettingsWithingsViewController *withingsController;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;

@end

@implementation DiaryViewController

@synthesize syncWithingsLabel;


-(void)viewDidLoad {
    
    syncWithingsLabel.text = @"";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
    self.diaryData = [[NSMutableArray alloc] init];
    
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    delegate.diaryViewController = self;
    
    DBManager *manager = [DBManager getSharedInstance];
    int count = [manager GetMeasurementsCount];
    for (int i = 1; i <= count; i++) {
        NSArray *entries = [manager getMeasurementResult:i];
        DiaryEntry *newEntry = [[DiaryEntry alloc] init];
        
        newEntry.date =[NSString stringWithFormat:@"%@",[entries objectAtIndex:5]];
        newEntry.value =[NSString stringWithFormat:@"%@",[entries objectAtIndex:1]];
        newEntry.unit = [NSString stringWithFormat:@"%@",[entries objectAtIndex:2]];
        
        [self.diaryData addObject:newEntry];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ch_bfh_bti8108_groupbjjmAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    self.withingsController = delegate.withingsController;
    
    /*
     If user has not registered withings, refreshcontrol should be insantiated => string must be removed.
     */
    if (![self.withingsController.oauthToken length]==0) {
        self.oauthToken = self.withingsController .oauthToken;
        self.oauthTokenSecret = self.withingsController.oauthTokenSecret;
        userId = @"4899465"; ///HARDCODED
        
        syncWithingsLabel.text = @"Herunterziehen um mit Withings zu synchronisieren";
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        self.refreshControl.tintColor = [UIColor whiteColor];
        [self.refreshControl addTarget:self
                                action:@selector(getWithingsData)
                      forControlEvents:UIControlEventValueChanged];
    }
    
    if (delegate.navigationFromCheckupView) {
        [self performSegueWithIdentifier:@"addDiaryEntry" sender:self];
        delegate.navigationFromCheckupView = false;
    }
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
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getmeas" forKey:@"action"];
    [dict setObject:userId forKey:@"userid"];
    //[dict setObject:@"1" forKey:@"meastype"];
    [dict setObject:@"1" forKey:@"category"]; //get measurements not user objectives
    NSLog(@"self.oauthToken=%@,self.oauthTokenSecret=%@",self.oauthToken,self.oauthTokenSecret);
    
    //Create
    NSURLRequest *request =
    [OAuth1Controller preparedRequestForPath:@"measure"
                                  parameters:dict
                                  HTTPmethod:@"GET"
                                  oauthToken:self.oauthToken
                                 oauthSecret:self.oauthTokenSecret];

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
                    
                     //    meastype
                     //    1 : Weight (kg)
                     //    9 : Diastolic Blood Pressure (mmHg)
                     //    10 : Systolic Blood Pressure (mmHg)
                     //    11 : Heart Pulse (bpm)
                     
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
         
             [self reloadData];
     }];


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *valueCellIdentifier = @"DiaryTableCell";
    DiaryTableCell *cell = (DiaryTableCell *)[self.tableView dequeueReusableCellWithIdentifier:valueCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DiaryTableCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DiaryEntry *currentEntry = [self.diaryData objectAtIndex:indexPath.row];
    
    [cell.dateLabel setText: [NSString stringWithFormat:@"%@", currentEntry.date]]; //@"18-12-2014 23:00";//currentEntry.date;
    [cell.valueLabel setText: [NSString stringWithFormat:@"%@", currentEntry.value]]; // @"180/180";//currentEntry.value;
    [cell.unitLabel setText: [NSString stringWithFormat:@"%@", currentEntry.unit]]; //@"mmol/L"; //currentEntry.unit;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.diaryData count];
}

/**
 *  Formats a given String with a Unix Date
 *
 *  @param datestring A UNIX Timestamp
 *
 *  @return String with Date Formatted like: dd.MM.yyyy HH:mm
 */
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

- (IBAction)unwindToDiaryView:(UIStoryboardSegue *)segue
{
    TagebucheintraegePageViewController *source = [segue sourceViewController];
    
    NSArray *diaryEntries = @[source.GewichtLabel.text,
                             source.BlutzuckerField.text,
                             source.GlucoseField.text,
                             source.HbA1cField.text,
                              source.PulsLabel.text];
    NSArray *units = @[@"kg",@"mmHg",@"mmol/l",@"mmol/l", @"bpm"];
    
    NSString *prePost = source.glucoseIsBeforeMealBool ? @" (N)":@" (P)";
    DBManager *manager = [DBManager getSharedInstance];
    for (int i = 0; i<5; i++) {
        
        NSString * text = [NSString stringWithFormat:@"%@", [diaryEntries objectAtIndex:i] ];

        if (!(text.length == 0 || [text isEqual:@"-"])) {
            DiaryEntry *newEntry = [[DiaryEntry alloc] init];
            newEntry.date = source.DatumDateLabel.text;
            newEntry.value = i == 2 ? [text stringByAppendingString:prePost] : text;
            newEntry.unit = [units objectAtIndex:i];
            [self.diaryData addObject:newEntry];
            
            [manager
             saveMeasurement:newEntry.value.floatValue
             measurementUnit:newEntry.unit
             upperLimit:newEntry.value.floatValue
             lowerLimit:newEntry.value.floatValue
             isBeforeMeal:source.glucoseIsBeforeMealBool]; //TODO save real Limit Data
        }
        
    }
    
    NSArray *sortedArray = [self.diaryData sortedArrayUsingComparator:^NSComparisonResult(DiaryEntry *e1, DiaryEntry *e2){
        return [e1.date compare:e2.date];
    }];
    
    self.diaryData = sortedArray.mutableCopy;
    
    [self.tableView reloadData];

}

- (IBAction)unwindFromAnotherViewToDiaryView:(UIStoryboardSegue *)segue
{

}

@end
