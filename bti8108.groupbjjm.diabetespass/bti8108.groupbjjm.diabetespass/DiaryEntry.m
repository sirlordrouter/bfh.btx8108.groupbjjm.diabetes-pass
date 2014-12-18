//
//  Glucose.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 17.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "DiaryEntry.h"
#import "ch_bfh_bti8108_groupbjjmAppDelegate.h"

@implementation DiaryEntry

//@dynamic unit, date, value;


- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToEntry:other];
}

- (BOOL)isEqualToEntry:(DiaryEntry *)anEntry {
    if (self == anEntry)
        return YES;
    if (![(id)[self unit] isEqual:[anEntry unit]])
        return NO;
    if (![[self date] isEqual:[anEntry date]])
        return NO;
    if (![[self value] isEqual:[anEntry value]])
        return NO;
    return YES;
}

- (NSComparisonResult)compare:(DiaryEntry *)otherObject {
    return [self.date compare:otherObject.date];
}


@end
