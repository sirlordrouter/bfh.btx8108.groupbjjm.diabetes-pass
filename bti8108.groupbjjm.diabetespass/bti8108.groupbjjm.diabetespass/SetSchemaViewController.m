//
//  SetSchemaViewController.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 11.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "SetSchemaViewController.h"

@implementation SetSchemaViewController




- (IBAction)unwindToSchemaView:(UIStoryboardSegue *)segue
{
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.saveButton) return;
    //else if did schema change? => store new data

}




@end
