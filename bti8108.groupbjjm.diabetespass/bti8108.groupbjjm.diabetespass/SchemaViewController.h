//
//  SchemaView.h
//  diabetesApp
//
//  Created by Johannes Gnägi on 11.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchemaBaseController.h"
#import "SchemaViewDaySelection.h"

@interface SchemaViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *setSchemaDaySelection;
- (IBAction)unwindToSchemaView:(UIStoryboardSegue *)segue;

@end
