//
//  Glucose.h
//  diabetesApp
//
//  Created by Johannes Gnägi on 17.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DiaryEntry : NSObject

/*
 mmol or dl/kg
 */
@property NSString *unit;
/* Datum */
@property NSString *date;
/* value of*/
@property NSString *value;
/* Glucose, Pressure etc.*/
@property NSString *unitLabel;
/* pre or postprandial*/
@property NSString *isBeforeMeal;

@end
