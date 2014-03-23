//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "CustomTableViewCell.h"
#import "AFNetworking.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "JSONModelLib.h"
#import "BusinessModel.h"

static NSString *CellIdentifier = @"CustomTableViewCell";

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UISearchDisplayController *searchController;
@property (nonatomic,strong) YelpModel *yelpModel;
@property (nonatomic,strong) NSArray *businessesList;
@property (nonatomic,strong) NSMutableDictionary *offscreenCells;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
            self.businessesList=[response objectForKey:@"businesses"];
           // NSLog(@"response: %@", response);
            [self.tableView reloadData];
            
            
//            NSError *e = nil;
//            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: response options: NSJSONReadingMutableContainers error: &e];
//            if (!jsonArray) {
//                NSLog(@"Error parsing JSON: %@", e);
//            } else {
//                for(NSDictionary *item in jsonArray) {
//                    NSLog(@"Item: %@", item);
//                }
//            }

//            NSError *initError=[[NSError alloc] init];
//            self.yelpModel=[self.yelpModel initWithDictionary:response error:&initError];
//            NSLog(@"json fetched: %@", self.yelpModel.businesses);
//            //NSLog(@"initError: %@", [initError description]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
    
//    //fetch the feed
//    self.yelpModel = [[YelpModel alloc] initFromURLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"
//                                         completion:^(JSONModel *model, JSONModelError *err) {
//                                             
//                                             //hide the loader view
//                                             [HUD hideUIBlockingIndicator];
//                                             
//                                             //json fetched
//                                             NSLog(@"loans: %@", _feed.loans);
//                                             
//                                         }];
//}

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.offscreenCells = [[NSMutableDictionary alloc] init];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    
    /*self.searchController = [[UISearchDisplayController alloc]
                        initWithSearchBar:searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchDisplayController.displaysSearchBarInNavigationBar=YES; */
    self.title=@"Yelp";
    
    UINib *customCellNib= [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
    
    
    self.tableView.dataSource=self;
    self.tableView.autoresizesSubviews=false;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.businessesList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 126;
//    
//    CustomTableViewCell *cell = [self.offscreenCells objectForKey:CellIdentifier];
//    if (!cell) {
//        cell = [[CustomTableViewCell alloc] init];
//        [self.offscreenCells setObject:cell forKey:CellIdentifier];
//    }
//    
//    NSDictionary *business=self.businessesList[indexPath.row];
//    cell.Name.text = [NSString stringWithFormat:@"%@",[business objectForKey:@"name"]];
//    
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    
//    // Set the width of the cell to match the width of the table view. This is important so that we'll get the
//    // correct cell height for different table view widths if the cell's height depends on its width (due to
//    // multi-line UILabels word wrapping, etc). We don't need to do this above in -[tableView:cellForRowAtIndexPath]
//    // because it happens automatically when the cell is used in the table view.
//    // Also note, the final width of the cell may not be the width of the table view in some cases, for example when a
//    // section index is displayed along the right side of the table view. You must account for the reduced cell width.
//    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
//    NSLog(@"cell bounds w h: %f %f",cell.bounds.size.width,cell.bounds.size.height);
//    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints.
//    // (Note that you must set the preferredMaxLayoutWidth on multi-line UILabels inside the -[layoutSubviews] method
//    // of the UITableViewCell subclass, or do it manually at this point before the below 2 lines!)
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];
//    
//    // Get the actual height required for the cell's contentView
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    // Add an extra point to the height to account for the cell separator, which is added between the bottom
//    // of the cell's contentView and the bottom of the table view cell.
//    height += 1.0f;
//  return height;
    NSDictionary *business=self.businessesList[indexPath.row];
    NSString* name=[NSString stringWithFormat:@"%@",[business objectForKey:@"name"]];
    NSLog(@"---- movie: %@",name);
    UIFont *font = [UIFont boldSystemFontOfSize: 28];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [name boundingRectWithSize:CGSizeMake(320, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    CGSize size= rect.size;
//    CGSize size = [name sizeWithAttributes:attributes];
    NSLog(@"---- height: %f",size.height);
    NSLog(@"---- returning height: %f",size.height+126);
    return size.height+126;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"
//                                                          forIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                          forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *business=self.businessesList[indexPath.row];
    NSString* name=[NSString stringWithFormat:@"%@",[business objectForKey:@"name"]];
    [cell.Name setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.Name setNumberOfLines:0];
    cell.Name.text = name;
    cell.Reviews.text = [NSString stringWithFormat:@"%@",[business objectForKey:@"phone"]];
    //[cell.Image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[business objectForKey:@"phone"]]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    //NSLog(@"--movie: %@",cell.Name.text);
    UIFont *font = [UIFont boldSystemFontOfSize: 28];
    NSDictionary *attributes = @{NSFontAttributeName: font};


    CGRect rect = [name boundingRectWithSize:CGSizeMake(cell.Name.bounds.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    CGSize size=rect.size;
    //CGSize size = [name sizeWithAttributes:attributes];
    cell.Name.frame = CGRectMake(0, 0, size.width, size.height);

    //NSLog(@"--height: %f",size.height);
    [cell.Name sizeToFit];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
