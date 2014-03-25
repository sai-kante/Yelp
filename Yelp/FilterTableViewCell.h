//
//  FilterTableViewCell.h
//  Yelp
//
//  Created by Sai Kante on 3/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterTableViewCellDelegate <NSObject>

@optional
- (void)filterTableViewCell:(id)sender onToggleSwitch: (BOOL)onOff;

@end

@interface FilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Description;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) id<FilterTableViewCellDelegate> delegate;
@end
