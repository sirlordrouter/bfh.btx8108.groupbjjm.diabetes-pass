//
//  SchemaViewDaySelection.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 12.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//
//  Class to Display a blue rectancle (for schema view) size and position is provided when initalized

#import "SchemaViewDaySelection.h"

@implementation SchemaViewDaySelection


- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self drawRect:aRect];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGRect rectangle = rect;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 122.0/255.0, 1.0,0.5);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.1);
    CGContextFillRect(context, rectangle);
    CGContextStrokeRect(context, rectangle);
    
}

@end
