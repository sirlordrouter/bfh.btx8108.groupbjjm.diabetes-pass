//
//  DBManager.m
//  NotfallPass2
//
//  Created by Jan Wiebe van der Sluis on 11/12/14.
//  Copyright (c) 2014 Jan Wiebe van der Sluis. All rights reserved.
//

#import "DBManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
static int numberOfMeasurementsInDB;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

//Creating the tables measurements and schematable with attributes: measurementsID (integer), measurementValue (Double NOT NULL), unit (string NOT NULL), upperLimit (double), lowerLimit (double), dateOfMeasurement (date NOT NULL), isBeaforeMeal (integer 0 for False, 1 for True). Schematable with attribute currentschema (string)
-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    //Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSLog(docsDir); //The directory of the created database in NSLog, can be opened with sqlitebrowser
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"adamDB.db"]];//Builds the path to the database file
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    
    if ([filemgr fileExistsAtPath: databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMSG;
          
            const char *sql_stmt_measurementTable = "create table if not exists measurements (measurementID integer primary key, measurementValue string NOT NULL, unit text NOT NULL, upperLimit double, lowerLimit double, dateOfMeasurement date NOT NULL, isBeforeMeal integer)";
            
            const char *sql_stmt_schemaTable = "create table if not exists schema (currentschema text)";
            
            if (sqlite3_exec(database, sql_stmt_measurementTable, NULL, NULL, &errMSG) != SQLITE_OK){
                isSuccess = NO;
                NSLog(@"Failed to create measurementTable");
            }
            
            if (sqlite3_exec(database, sql_stmt_schemaTable, NULL, NULL, &errMSG) != SQLITE_OK){
                isSuccess = NO;
                NSLog(@"Failed to create table schemaTable");
            }
           
        else {
            isSuccess = YES;
           
            NSLog(@"Database succesfully created");
            //NSLog(@"Failed to open/create database");
                  }
        }
    
}
    return isSuccess;
}






//saveMeasurement Method. Returns TRUE if save was succesfull. Returns FALSE if save failed.
-(BOOL) writeMeasurementInDB:(NSString*)measurementValue measurementUnit:(NSString *)unit upperLimit:(double)upperLimit lowerLimit:(double)lowerLimit isBeforeMeal:(Boolean)isBeforeMeal aDate:(NSString*)date {
    
    int idNumber = [self GetMeasurementsCount]+1;
    int flag = (isBeforeMeal)? 1 : 0; //Because sqlite only saves 1 (true) or 0 (false) values for Boolean types
    
    const char *dbpath = [databasePath UTF8String];
    
    statement = nil;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
    
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into measurements (measurementID, measurementValue, unit, upperLimit, lowerLimit, dateOfMeasurement, isBeforeMeal) values(%d,\"%@\",\"%@\",%f,%f,\"%@\",%d)", (int)idNumber, (NSString*)measurementValue, unit, (double)upperLimit, (double)lowerLimit, date, (int)flag];

        const char *insert_stmt_measurement = [insertSQL UTF8String];
        
        int rc = sqlite3_prepare(database, insert_stmt_measurement, -1, &statement, NULL);
        
        if (rc != SQLITE_OK) {
            sqlite3_close(database);
            return NO;
        }
        
        rc = sqlite3_step(statement);
        
        if (rc == SQLITE_DONE) {
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }
        else{
            sqlite3_finalize(statement);
            sqlite3_close(database);
             NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
            return NO;
        }
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(database);


   return NO;
}


//Returns the number of Measurements (Integer) in the database.
- (int) GetMeasurementsCount
{
    numberOfMeasurementsInDB = 0;
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char* sqlStatement = "SELECT COUNT(*) FROM measurements";
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                numberOfMeasurementsInDB = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    return numberOfMeasurementsInDB;
}


//saveMeasurement method. The Date of the measurements is automatically created in the writeMeasurementInDB method.
-(void) saveMeasurement:(NSString*)measurementValue measurementUnit:(NSString *)measurementUnit upperLimit:(double)upperLimit lowerLimit:(double)lowerLimit isBeforeMeal:(Boolean)isBeforeMeal aDate:(NSString*)date {
    
    bool success = [[DBManager getSharedInstance]writeMeasurementInDB:measurementValue measurementUnit:measurementUnit upperLimit:upperLimit lowerLimit:lowerLimit isBeforeMeal:isBeforeMeal aDate:date];
   
    if (success == YES) {
        
        //UIAlertView *succesAlert = [[UIAlertView alloc]initWithTitle:@"Measurement saved" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[succesAlert show];
    }
    else{
       // UIAlertView *failedAlert =[[UIAlertView alloc]initWithTitle:@"Save Failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
       // [failedAlert show];
        NSLog( @"Failed to save. Error is:  %s", sqlite3_errmsg(database) );
    }
}


// Returns a resultarray with the measurementID, measurementvalue, measurementUnit, upperLimit, lowerLimit, Date of Measurement (NSDate) and a boolean isBeforeMeal (1=true, 0=false). The result are from the measurementID given.
- (NSArray*) getMeasurementResult:(NSInteger)measurementID{
    const char *dbpath = [databasePath UTF8String];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select measurementID, measurementValue, unit, upperLimit, lowerLimit, dateOfMeasurement, isBeforeMeal from measurements where measurementID=%d", (int) measurementID];
         const char *query = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK){
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSNumber *measurementID = [NSNumber numberWithInteger:sqlite3_column_int(statement, 0)];
            [resultArray addObject:measurementID];
            
            NSString *measurementValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,1)];
            [resultArray addObject:measurementValue];
            
            NSString *measurementUnit = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
            [resultArray addObject:measurementUnit];
            
            NSNumber *upperLimit = [NSNumber numberWithDouble:sqlite3_column_double(statement, 3)];
            [resultArray addObject:upperLimit];
            
            NSNumber *lowerLimit = [NSNumber numberWithDouble:sqlite3_column_double(statement, 4)];
            [resultArray addObject:lowerLimit];
            
            NSString *stringDateOfMeasurement = [[NSString alloc] initWithUTF8String: (const char *)sqlite3_column_text(statement, 5)];
            
            [resultArray addObject:stringDateOfMeasurement];
          
            NSNumber *isBeforeMealNumber = [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
            [resultArray addObject:isBeforeMealNumber];
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
            return resultArray;
            
            
                                        
        }}
        else
        {
            NSLog(@"Building resultarray failed");
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return nil;
}


//Save currentschema in database in Stringformat
-(BOOL)saveCurrentSchema:(NSString *)currentSchema{
    
    const char *dbPath = [databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into schema (currentschema) values(\"%@\")",currentSchema];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
    }
    if (sqlite3_step(statement)== SQLITE_DONE) {
        sqlite3_finalize(statement);
        sqlite3_close(database);
        
        return YES;
    }
    else {
        sqlite3_finalize(statement);
        sqlite3_close(database);
        NSLog(@"Failed from insertion in currentschema. Error is: %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(database);

}

@end


