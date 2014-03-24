//
//  FiltersViewController.h
//  Yelp
//
//  Created by Sai Kante on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FiltersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *TableView;

@end
