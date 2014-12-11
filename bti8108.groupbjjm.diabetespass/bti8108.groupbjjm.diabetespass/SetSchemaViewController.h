//
//  SetSchemaViewController.h
//  diabetesApp
//
//  Created by Johannes Gnägi on 11.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetSchemaViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)unwindToSchemaView:(UIStoryboardSegue *)segue;


@end
