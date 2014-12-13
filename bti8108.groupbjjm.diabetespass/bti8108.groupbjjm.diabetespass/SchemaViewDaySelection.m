//
//  SchemaViewDaySelection.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 12.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

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
    
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2.0);
//    UIColor *ios7BlueColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
//    CGContextSetStrokeColorWithColor(context, ios7BlueColor.CGColor);
//    CGRect rectangle = CGRectMake(7,155,306,30);
//    CGContextAddRect(context, rectangle);
//    CGContextStrokePath(context);
    
    // build day
    //CGRect rectangle = CGRectMake(7,155,306,30);
    CGRect rectangle = rect;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 122.0/255.0, 1.0,0.5);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.1);
    CGContextFillRect(context, rectangle);
    CGContextStrokeRect(context, rectangle);
    
}




@end
