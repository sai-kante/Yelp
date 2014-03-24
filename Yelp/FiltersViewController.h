//
//  FiltersViewController.h
//  Yelp
//
//  Created by Sai Kante on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FiltersViewControllerDelegate <NSObject>

@optional
- (void)setDealsInSearch:(BOOL)onOff;
- (void)sortByInSearch:(NSString *)sortBy;
- (void)distanceInSearch:(NSString *)distance;
- (void)categoriesInSearch:(NSString *)categories;

@end

@interface FiltersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;
@end
