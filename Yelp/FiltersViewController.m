//
//  FiltersViewController.m
//  Yelp
//
//  Created by Sai Kante on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "FilterTableViewCell.h"

static NSString *CellIdentifier = @"FilterTableViewCell";

@interface FiltersViewController ()

@property (nonatomic,strong) NSArray *categoriesIndexPaths;
@property (nonatomic,strong) NSArray *dealsIndexPaths;
@property (nonatomic,strong) NSArray *sortByIndexPaths;
@property (nonatomic,strong) NSArray *distanceIndexPaths;
@property (nonatomic,strong) NSMutableDictionary *numberOfRowsWhenExpanded;
@property (nonatomic,strong) NSArray *dealsOptions;
@property (nonatomic,strong) NSArray *sortByOptions;
@property (nonatomic,strong) NSArray *distanceOptions;
@property (nonatomic,strong) NSArray *categoriesOptions;
@property (nonatomic,strong) NSMutableDictionary *optionsChosen;

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *customCellNib= [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.TableView registerNib:customCellNib forCellReuseIdentifier:CellIdentifier];
    
    self.dealsIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:1 inSection:0],
                                 nil];
    self.sortByIndexPaths = [NSArray arrayWithObjects:
                            [NSIndexPath indexPathForRow:1 inSection:1],
                            [NSIndexPath indexPathForRow:2 inSection:1],
                            nil];
    self.distanceIndexPaths = [NSArray arrayWithObjects:
                            [NSIndexPath indexPathForRow:1 inSection:2],
                            [NSIndexPath indexPathForRow:2 inSection:2],
                            [NSIndexPath indexPathForRow:3 inSection:2],
                            nil];
    self.categoriesIndexPaths = [NSArray arrayWithObjects:
                            [NSIndexPath indexPathForRow:1 inSection:3],
                            [NSIndexPath indexPathForRow:2 inSection:3],
                            [NSIndexPath indexPathForRow:3 inSection:3],
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
    self.numberOfRowsWhenExpanded[@0]=[NSNumber numberWithInt:2];
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
                              @"cat 1",@"cat 2", @"cat 3",@"cat 4",@"cat 5",
                              @"cat 6",@"cat 7", @"cat 8",@"cat 9",@"cat 10",nil];
    
    //set default options chosen
    self.optionsChosen= [[NSMutableDictionary alloc] init];
    self.optionsChosen[@"Deals"]=[NSString stringWithFormat:@"%@",self.dealsOptions[0]];
    self.optionsChosen[@"SortBy"]=[NSString stringWithFormat:@"%@",self.sortByOptions[0]];;
    self.optionsChosen[@"Distance"]=[NSString stringWithFormat:@"%@",self.distanceOptions[0]];;
    self.optionsChosen[@"Categories"]=[NSString stringWithFormat:@"%@",self.categoriesOptions[0]];;
    
    
    self.TableView.dataSource=self;
    self.TableView.autoresizesSubviews=false;
    self.TableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString* name=[[NSString alloc] init];
    //0: @"Deals", 1: @"SortBy", 2:@"Distance", 3:@"Categories"
    if(expanded[indexPath.section])
    {
        switch(indexPath.section) {
            case 0:
                name=self.dealsOptions[indexPath.row];
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
                name=self.optionsChosen[@"Deals"];
                break;
            case 1:
                name=self.optionsChosen[@"SortBy"];
                break;
            case 2:
                name=self.optionsChosen[@"Distance"];
                break;
            case 3:
                name=self.optionsChosen[@"Categories"];
                break;
        }
    }
    
    
    cell.Description.text=name;
//    UITableViewCell *cell = [[UITableViewCell alloc] init];// [tableView dequeueReusableCellWithIdentifier:@"MyReuseIdentifier"];
//    cell.textLabel.text=[NSString stringWithFormat:@"%@",[self.myStrings objectAtIndex:indexPath.row]];// @"cat";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //toggle the table view first
    expanded[indexPath.section]=!expanded[indexPath.section];
    
    //[self.TableView reloadData ];
    if(expanded[indexPath.section]) {
        //expand to rows
        switch(indexPath.section) {
            case 0:
                [self.TableView insertRowsAtIndexPaths:self.dealsIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 1:
                [self.TableView insertRowsAtIndexPaths:self.sortByIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 2:
                [self.TableView insertRowsAtIndexPaths:self.distanceIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 3:
                [self.TableView insertRowsAtIndexPaths:self.categoriesIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
        
        //[self.TableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else {
        //[self.TableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        
        //save the option and collapse
        switch(indexPath.section) {
            case 0:
                self.optionsChosen[@"Deals"]=[NSString stringWithFormat:@"%@",self.dealsOptions[indexPath.row]];
                [self.TableView deleteRowsAtIndexPaths:self.dealsIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 1:
                self.optionsChosen[@"SortBy"]=[NSString stringWithFormat:@"%@",self.sortByOptions[indexPath.row]];
                [self.TableView deleteRowsAtIndexPaths:self.sortByIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 2:
                self.optionsChosen[@"Distance"]=[NSString stringWithFormat:@"%@",self.distanceOptions[indexPath.row]];
                [self.TableView deleteRowsAtIndexPaths:self.distanceIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
            case 3:
                self.optionsChosen[@"Categories"]=[NSString stringWithFormat:@"%@",self.categoriesOptions[indexPath.row]];
                [self.TableView deleteRowsAtIndexPaths:self.categoriesIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
    //reload that section
    [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor= [UIColor redColor];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
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
            break;
    }
    [headerView addSubview:label];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 31;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(self.expanded) {
//        return 140;
//    }
//    else {
//        return 70;
//    }
//}


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	NSDictionary *dict=[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
	self.items=[dict valueForKey:@"Items"];
	self.itemsInTable=[[NSMutableArray alloc] init];
	[self.itemsInTable addObjectsFromArray:self.items];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Title= [[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"Name"];
    
    return [self createCellWithTitle:Title image:[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"Image name"] indexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[self.itemsInTable objectAtIndex:indexPath.row];
    if([dic valueForKey:@"SubItems"])
    {
        NSArray *arr=[dic valueForKey:@"SubItems"];
        BOOL isTableExpanded=NO;
        
        for(NSDictionary *subitems in arr )
        {
            NSInteger index=[self.itemsInTable indexOfObjectIdenticalTo:subitems];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        
        if(isTableExpanded)
        {
            [self CollapseRows:arr];
        }
        else
        {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(NSDictionary *dInner in arr )
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.itemsInTable insertObject:dInner atIndex:count++];
            }
            [self.TableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

-(void)CollapseRows:(NSArray*)ar
{
	for(NSDictionary *dInner in ar )
    {
		NSUInteger indexToRemove=[self.itemsInTable indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"SubItems"];
		if(arInner && [arInner count]>0)
        {
			[self CollapseRows:arInner];
		}
		
		if([self.itemsInTable indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
			[self.itemsInTable removeObjectIdenticalTo:dInner];
			[self.TableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                        [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                        ]
                                      withRowAnimation:UITableViewRowAnimationLeft];
        }
	}
}

- (UITableViewCell*)createCellWithTitle:(NSString *)title image:(UIImage *)image  indexPath:(NSIndexPath*)indexPath
{
    NSString *CellIdentifier = @"Cell";
    ExpandableTableViewCell* cell = [self.TableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = bgView;
    cell.lblTitle.text = title;
    cell.lblTitle.textColor = [UIColor blackColor];
    
    [cell setIndentationLevel:[[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    cell.indentationWidth = 25;
    
    float indentPoints = cell.indentationLevel * cell.indentationWidth;
    
    cell.contentView.frame = CGRectMake(indentPoints,cell.contentView.frame.origin.y,cell.contentView.frame.size.width - indentPoints,cell.contentView.frame.size.height);
    
    NSDictionary *d1=[self.itemsInTable objectAtIndex:indexPath.row] ;
    
    if([d1 valueForKey:@"SubItems"])
    {
        cell.btnExpand.alpha = 1.0;
        [cell.btnExpand addTarget:self action:@selector(showSubItems:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.btnExpand.alpha = 0.0;
    }
    return cell;
}

-(void)showSubItems :(id) sender
{
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.TableView];
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    if(btn.alpha==1.0)
    {
        if ([[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"down-arrow.png"]])
        {
            [btn setImage:[UIImage imageNamed:@"up-arrow.png"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
        }
        
    }
    
    NSDictionary *d=[self.itemsInTable objectAtIndex:indexPath.row] ;
    NSArray *arr=[d valueForKey:@"SubItems"];
    if([d valueForKey:@"SubItems"])
    {
        BOOL isTableExpanded=NO;
        for(NSDictionary *subitems in arr )
        {
            NSInteger index=[self.itemsInTable indexOfObjectIdenticalTo:subitems];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        
        if(isTableExpanded)
        {
            [self CollapseRows:arr];
        }
        else
        {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(NSDictionary *dInner in arr )
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.itemsInTable insertObject:dInner atIndex:count++];
            }
            [self.TableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    
    
}
 */
@end
