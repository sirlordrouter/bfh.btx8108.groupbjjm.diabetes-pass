//
//  SchemaViewController.h
//  diabetesApp
//
//  Created by Johannes Gnägi on 08.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsSchemaView.h"

@interface SettingsSchemaViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet SettingsSchemaView *schemaView;
@property (weak, nonatomic) IBOutlet UIPickerView *schemaPicker;
@property (strong, nonatomic) NSArray *pickerDefaults;

@end
