//
//  SetSchemaViewController.h
//  diabetesApp
//
//  Created by Johannes Gnägi on 11.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetSchemaViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *defaultSchemePicker;
@property (weak, nonatomic) IBOutlet UIButton *changeSchema;

@property (weak, nonatomic) IBOutlet UIView *schemaViewCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *intervallCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *intervallPickerCell;

@property (assign) BOOL defaultPickerIsShowing;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)unwindToSchemaView:(UIStoryboardSegue *)segue;


@property (strong, nonatomic) NSArray *pickerDefaults;

@end


