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
#import <SDWebImage/UIImageView+WebCache.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString *CellIdentifier = @"CustomTableViewCell";
static int CustomTableViewCellHeight=103;
static int NameLabelFontSize=17;
static int NameLabelWidth=182;

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UISearchDisplayController *searchController;
@property (nonatomic,strong) NSArray *businessesList;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) FiltersViewController *filtersView;
@property (nonatomic,strong) NSMutableDictionary *optionsChosen;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self searchYelpWithString:@"Restaurant"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40.0, 0.0, 280.0, 44.0)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.barTintColor = [UIColor colorWithRed:255/255.0f green:74/255.0f blue:68/255.0f alpha:1.0f];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor blackColor]];
    
    UIButton *filterButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [filterButton addTarget:self action:@selector(onFilterButton:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    //filterButton.backgroundColor=[UIColor colorWithRed:255/255.0f green:74/255.0f blue:68/255.0f alpha:1.0f];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    self.searchBar.delegate = self;
    [searchBarView addSubview:filterButton];
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    UINib *customCellNib= [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
    
    
    self.tableView.dataSource=self;
    self.tableView.autoresizesSubviews=false;
    self.tableView.delegate = self;
    
    //set the filters view controller
    self.filtersView=[[FiltersViewController alloc] init];
    self.filtersView.delegate=self;
    
    self.optionsChosen= [[NSMutableDictionary alloc] init];
    self.optionsChosen[@"Deals"]=@"off";
    self.optionsChosen[@"SortBy"]=@"";
    self.optionsChosen[@"Distance"]=@"";
    self.optionsChosen[@"Categories"]=@"";
    
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
    CustomTableViewCell *cell = [[CustomTableViewCell alloc] init];
    NSDictionary *business=self.businessesList[indexPath.row];
    NSString* name=[NSString stringWithFormat:@"%@",[business objectForKey:@"name"]];
    [cell.Name setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.Name setNumberOfLines:0];
    cell.Name.text = name;
    UIFont *font = [UIFont boldSystemFontOfSize: NameLabelFontSize];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    CGRect rect = [name boundingRectWithSize:CGSizeMake(NameLabelWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    CGSize size=rect.size;
    //cell.Name.frame = CGRectMake(0, 0, size.width, size.height);
    
    NSLog(@"----%@ height: %f",name,size.height);
    [cell.Name sizeToFit];
    
    /* NSDictionary *business=self.businessesList[indexPath.row];
    NSString* name=[NSString stringWithFormat:@"%@",[business objectForKey:@"name"]];
    UIFont *font = [UIFont boldSystemFontOfSize: NameLabelFontSize];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [name boundingRectWithSize:CGSizeMake(320, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    CGSize size= rect.size;
//    CGSize size = [name sizeWithAttributes:attributes];
    NSLog(@"---- %@ height: %f",name,size.height);
    NSLog(@"---- returning height: %f",size.height+CustomTableViewCellHeight);
    */
    return size.height+CustomTableViewCellHeight;
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
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *business=self.businessesList[indexPath.row];
    NSString* name=[NSString stringWithFormat:@"%@",[business objectForKey:@"name"]];
    [cell.Name setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.Name setNumberOfLines:0];
    cell.Name.text = name;
    cell.Reviews.text = [NSString stringWithFormat:@"%@ Reviews",[business objectForKey:@"review_count"]];
    [cell.Image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[business objectForKey:@"image_url"]]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    [cell.ReviewsImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[business objectForKey:@"rating_img_url_small"]]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    
    
    NSDictionary *location=[business objectForKey:@"location"];
    NSArray *address=[[NSArray alloc] init];
    if(location) {
        address=[location objectForKey:@"display_address"];
    }
    if(address) {
        cell.Address.text=address[0];
    }
    else {
        cell.Address.text=@"Not Available";
    }
    
    NSArray *categories=[business objectForKey:@"categories"];
    NSString *categoryList=@"";
    for (NSArray *eachCategory in categories) {
        categoryList = [categoryList stringByAppendingFormat:@"%@, ", eachCategory[0]];
    }
    if ([categoryList length] > 0) {
        categoryList = [categoryList substringToIndex:[categoryList length] - 2];
    }
    cell.Type.text=categoryList;
    
    
    //NSLog(@"--movie: %@",cell.Name.text);
    UIFont *font = [UIFont boldSystemFontOfSize: NameLabelFontSize];
    NSDictionary *attributes = @{NSFontAttributeName: font};

    //NSLog(@"--%@ width: %f const: %d",name,cell.Name.bounds.size.width,NameLabelWidth);

    CGRect rect = [name boundingRectWithSize:CGSizeMake(NameLabelWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    CGSize size=rect.size;
    //CGSize size = [name sizeWithAttributes:attributes];
    //cell.Name.frame = CGRectMake(0, 0, size.width, size.height);

    NSLog(@"--%@ height: %f",name,size.height);
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.Name.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)onFilterButton:(id)sender {
    self.filtersView.optionsChosen[@"Deals"]=self.optionsChosen[@"Deals"];
    self.filtersView.optionsChosen[@"SortBy"]=self.optionsChosen[@"SortBy"];
    self.filtersView.optionsChosen[@"Distance"]=self.optionsChosen[@"Distance"];
    self.filtersView.optionsChosen[@"Categories"]=self.optionsChosen[@"Categories"];
    [self.navigationController pushViewController:self.filtersView animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
    if(searchBar.text.length>0) {
        [self searchYelpWithString:searchBar.text];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}


-(void)searchYelpWithString:(NSString *)text {
    [self.client searchWithTerm:text success:^(AFHTTPRequestOperation *operation, id response) {
        self.businessesList=[response objectForKey:@"businesses"];
        // NSLog(@"response: %@", response);
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

#pragma mark - FiltersViewControllerDelegate

- (void)setDealsInSearch:(NSString* )onOff {
    self.optionsChosen[@"Deals"]=onOff;
}

- (void)sortByInSearch:(NSString *)sortBy {
    self.optionsChosen[@"SortBy"]=sortBy;
}

- (void)distanceInSearch:(NSString *)distance {
    self.optionsChosen[@"Distance"]=distance;
}

- (void)categoriesInSearch:(NSString *)categories {
    self.optionsChosen[@"Categories"]=categories;
}

- (void)searchUsingFilters {
    NSString *dealsChosen=[self.optionsChosen[@"Deals"] isEqualToString:@"off"] ? @"false": @"true";
    [self.client searchWithTerm:@"Restaurant" withDeals:dealsChosen sortBy:self.optionsChosen[@"SortBy"]
                                              inRadius:[self.optionsChosen[@"Distance"] intValue] inCategory:@"" success:^(AFHTTPRequestOperation *operation, id response) {
                                                  self.businessesList=[response objectForKey:@"businesses"];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

@end
