//
//  DiaryViewController.h
//  diabetesApp
//
//  Created by Johannes Gnägi on 16.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
    NSString *userId;
}


@property NSMutableArray *diaryData;
@property (weak, nonatomic) IBOutlet UILabel *syncWithingsLabel;
- (IBAction)unwindToDiaryView:(UIStoryboardSegue *)segue;
- (IBAction)unwindFromAnotherViewToDiaryView:(UIStoryboardSegue *)segue;

@end
