//
//  FiltersViewController.h
//  Yelp
//
//  Created by Sai Kante on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterTableViewCell.h"


@protocol FiltersViewControllerDelegate <NSObject>

@optional
- (void)setDealsInSearch:(NSString *)onOff; //uses strings "on" and "off"
- (void)sortByInSearch:(NSString *)sortBy;
- (void)distanceInSearch:(NSString *)distance;
- (void)categoriesInSearch:(NSString *)categories;
- (void)searchUsingFilters;

@end

@interface FiltersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, FilterTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;
@property (nonatomic,strong) NSMutableDictionary *optionsChosen;
@end
