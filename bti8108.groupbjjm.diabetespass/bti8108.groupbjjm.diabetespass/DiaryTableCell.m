//
//  DiaryTableCell.m
//  diabetesApp
//
//  Created by Johannes Gnägi on 17.12.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "DiaryTableCell.h"

@implementation DiaryTableCell

@synthesize dateLabel = _dateLabel;
@synthesize valueLabel = _valueLabel;
@synthesize unitLabel = _unitLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end