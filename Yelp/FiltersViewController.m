//
//  FiltersViewController.m
//  Yelp
//
//  Created by Sai Kante on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString *CellIdentifier = @"FilterTableViewCell";

@interface FiltersViewController ()

@property (nonatomic,strong) NSArray *extraCategoriesIndexPaths;
@property (nonatomic,strong) NSArray *sortByIndexPaths;
@property (nonatomic,strong) NSArray *distanceIndexPaths;
@property (nonatomic,strong) NSMutableDictionary *numberOfRowsWhenExpanded;
@property (nonatomic,strong) NSArray *dealsOptions;
@property (nonatomic,strong) NSArray *sortByOptions;
@property (nonatomic,strong) NSArray *distanceOptions;
@property (nonatomic,strong) NSArray *categoriesOptions;

@end

@implementation FiltersViewController
{
    BOOL expanded[4];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.optionsChosen= [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton:)];
    
    UINib *customCellNib= [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.TableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
    
    self.sortByIndexPaths = [NSArray arrayWithObjects:
                            [NSIndexPath indexPathForRow:1 inSection:1],
                            [NSIndexPath indexPathForRow:2 inSection:1],
                            nil];
    self.distanceIndexPaths = [NSArray arrayWithObjects:
                            [NSIndexPath indexPathForRow:1 inSection:2],
                            [NSIndexPath indexPathForRow:2 inSection:2],
                            [NSIndexPath indexPathForRow:3 inSection:2],
                            nil];
    // the fourth one is "see more"
    self.extraCategoriesIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:4 inSection:3],
                                 [NSIndexPath indexPathForRow:5 inSection:3],
                                 [NSIndexPath indexPathForRow:6 inSection:3],
                                 [NSIndexPath indexPathForRow:7 inSection:3],
                                 [NSIndexPath indexPathForRow:8 inSection:3],
                                 [NSIndexPath indexPathForRow:9 inSection:3],
                                 nil];
    
    //all the sections are not expanded when the view loads
    for(int i=0;i<4;i++) {
        expanded[i]=NO;
    }
    
    //set the number of rows
    self.numberOfRowsWhenExpanded=[[NSMutableDictionary alloc] init];
    //0: @"Deals", 1: @"SortBy", 2:@"Distance", 3:@"Categories"
    self.numberOfRowsWhenExpanded[@0]=[NSNumber numberWithInt:1];
    self.numberOfRowsWhenExpanded[@1]=[NSNumber numberWithInt:3];
    self.numberOfRowsWhenExpanded[@2]=[NSNumber numberWithInt:4];
    self.numberOfRowsWhenExpanded[@3]=[NSNumber numberWithInt:10];
    
    
    self.dealsOptions       = [NSArray arrayWithObjects:
                               @"on",@"off",nil];
    self.sortByOptions      = [NSArray arrayWithObjects:
                               @"best match",@"distance",@"highest rated",nil];
    self.distanceOptions    = [NSArray arrayWithObjects:
                               @"100 meters",@"500 meters",@"1000 meters", @"2000 meters",nil];
    self.categoriesOptions  = [NSArray arrayWithObjects:
                              @"Indian",@"Italian", @"Japanese",@"Korean",@"Mexican",
                              @"Pizza",@"Thai", @"Seafood",@"Sushi Bars",@"Greek",nil];
    
    //set default options chosen
    if([self.optionsChosen[@"SortBy"] isEqual:@""]) {
        self.optionsChosen[@"SortBy"]=[NSString stringWithFormat:@"%@",self.sortByOptions[0]];
    }
    if([self.optionsChosen[@"Distance"] isEqual:@""]) {
        self.optionsChosen[@"Distance"]=[NSString stringWithFormat:@"%@",self.distanceOptions[0]];
    }
    if([self.optionsChosen[@"Categories"] isEqual:@""]) {
        self.optionsChosen[@"Categories"]=[NSString stringWithFormat:@"%@",self.categoriesOptions[0]];
    }
    
    self.TableView.dataSource=self;
    self.TableView.autoresizesSubviews=false;
    self.TableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber* numRows=self.numberOfRowsWhenExpanded[@(section)];
    if(expanded[section]) {
        return [numRows integerValue];
    }
    else {
        if(section==3) {
            return 4;
        }
        else {
            return 1;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //disable the switch
    cell.toggleSwitch.hidden=YES;
    cell.toggleSwitch.enabled=NO;
    
    NSString* name=[[NSString alloc] init];
    //0: @"Deals", 1: @"SortBy", 2:@"Distance", 3:@"Categories"
    if(indexPath.section==0) {
        name=self.optionsChosen[@"Deals"];
        cell.toggleSwitch.hidden=NO;
        cell.toggleSwitch.enabled=YES;
        cell.delegate=self;
        
        //first set the current toggle state
        cell.toggleSwitch.on= [self.optionsChosen[@"Deals"] isEqualToString: @"on" ] ? YES : NO ;
        
    }
    else if(expanded[indexPath.section])
    {
        switch(indexPath.section) {
            case 0:
                break;
            case 1:
                name=self.sortByOptions[indexPath.row];
                break;
            case 2:
                name=self.distanceOptions[indexPath.row];
                break;
            case 3:
                name=self.categoriesOptions[indexPath.row];
                break;
        }
    }
    else {
        switch(indexPath.section) {
            case 0:
                break;
            case 1:
                name=self.optionsChosen[@"SortBy"];
                break;
            case 2:
                name=self.optionsChosen[@"Distance"];
                break;
            case 3:
                //name=self.optionsChosen[@"Categories"];
                if(indexPath.row==3)
                {
                    name=@"See more..";
                }
                else {
                    name=self.categoriesOptions[indexPath.row];
                }
                break;
        }
    }
    cell.Description.text=name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //toggle the table view first
    expanded[indexPath.section]=!expanded[indexPath.section];
    
    if(expanded[indexPath.section]) {
        //expand to rows
        switch(indexPath.section) {
            case 0:
                break;
            case 1:
                [self.TableView insertRowsAtIndexPaths:self.sortByIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 2:
                [self.TableView insertRowsAtIndexPaths:self.distanceIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 3:
                if(indexPath.row==3)
                {
                    // delete the see more row
                    //[self.TableView deleteRowsAtIndexPaths:self.categoriesIndexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
                    //insert other rows
                    [self.TableView insertRowsAtIndexPaths:self.extraCategoriesIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                }
                else {
                    self.optionsChosen[@"Categories"]=[NSString stringWithFormat:@"%@",self.categoriesOptions[indexPath.row]];
                    [self.delegate categoriesInSearch:self.optionsChosen[@"Categories"]];
                }
                break;
        }
    }
    else {
        //save the option and collapse
        switch(indexPath.section) {
            case 0:
                break;
            case 1:
                self.optionsChosen[@"SortBy"]=[NSString stringWithFormat:@"%@",self.sortByOptions[indexPath.row]];
                [self.delegate sortByInSearch:self.optionsChosen[@"SortBy"]];
                [self.TableView deleteRowsAtIndexPaths:self.sortByIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 2:
                self.optionsChosen[@"Distance"]=[NSString stringWithFormat:@"%@",self.distanceOptions[indexPath.row]];
                [self.delegate distanceInSearch:self.optionsChosen[@"Distance"]];
                [self.TableView deleteRowsAtIndexPaths:self.distanceIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 3:
                self.optionsChosen[@"Categories"]=[NSString stringWithFormat:@"%@",self.categoriesOptions[indexPath.row]];
                [self.delegate categoriesInSearch:self.optionsChosen[@"Categories"]];
                [self.TableView deleteRowsAtIndexPaths:self.extraCategoriesIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                // add the see more row
                //[self.TableView insertRowsAtIndexPaths:self.categoriesIndexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
    //reload that section
    [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headerView.backgroundColor= [UIColor grayColor];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 320, 20)];
    switch(section) {
        case 0:
            label.text=@"Deals";
            break;
        case 1:
            label.text=@"Sorty by";
            break;
        case 2:
            label.text=@"Radius";
            break;
        case 3:
            label.text=@"Categories";
            //if(![self.optionsChosen[@"Categories"] isEqualToString:@""]) {
            label.text=[label.text stringByAppendingFormat:@": %@", self.optionsChosen[@"Categories"]];
            //}
            break;
    }
    [headerView addSubview:label];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (IBAction)onCancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSearchButton:(id)sender {
    [self.delegate searchButtonClicked];
    [self.navigationController popViewControllerAnimated:YES];

}

# pragma mark - FiltersTableViewCellDelegate

-(void) filterTableViewCell:cell onToggleSwitch:(BOOL)onOff {
    //we only have a deals switch
    self.optionsChosen[@"Deals"]=onOff ? @"on" : @"off" ;
    //reload the section 0
    [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    //call the delegate method
    [self.delegate setDealsInSearch:self.optionsChosen[@"Deals"]];
}


@end
