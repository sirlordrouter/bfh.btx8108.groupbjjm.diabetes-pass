//
//  DBManager.h
//  NotfallPass2
//
//  Created by Jan Wiebe van der Sluis on 11/12/14.
//  Copyright (c) 2014 Jan Wiebe van der Sluis. All rights reserved.
//
//  Edited by Johannes Gnägi on 08-01-2015

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SQLite3.h>

@interface DBManager : NSObject
{NSString *databasePath;
}
+(DBManager*) getSharedInstance;
-(BOOL)createDB;
-(BOOL) writeMeasurementInDB:(NSString*)measurementValue measurementUnit:(NSString*)measurementUnit upperLimit:(double)upperLimit lowerLimit:(double)lowerLimit isBeforeMeal:(Boolean)isBeforeMeal aDate:(NSString*)date aUnitLabel:(NSString*)unitLabel;
-(void) saveMeasurement:(NSString*)measurementValue measurementUnit:(NSString*)measurementUnit upperLimit:(double)upperLimit lowerLimit:(double)lowerLimit isBeforeMeal:(Boolean)isBeforeMeal aDate:(NSString*)date aUnitLabel:(NSString*)unitLabel;
-(BOOL) saveCurrentSchema:(NSString*)currentSchema;
-(int) GetMeasurementsCount;

-(NSArray*) getMeasurementResult:(NSInteger)measurementID;

@end