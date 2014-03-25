//
//  FilterTableViewCell.m
//  Yelp
//
//  Created by Sai Kante on 3/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self.toggleSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)switchClicked:(id)sender {
    [self.delegate filterTableViewCell:self onToggleSwitch:self.toggleSwitch.on];
}

@end
