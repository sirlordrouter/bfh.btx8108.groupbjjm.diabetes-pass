//
//  SchemaView.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 08.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "SettingsSchemaView.h"

@implementation SettingsSchemaView

-(void) drawRect:(CGRect)rect {
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor: [UIColor yellowColor]];
        //[self initButtonMatrix];
    }
    return self;
}
     
     
@end
