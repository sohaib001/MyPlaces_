//
//  AllCategoriesViewController.m
//  MyPlaces_
//
//  Created by uraan on 11/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllCategoriesViewController.h"
#import "DataSource.h"


@implementation AllCategoriesViewController

@synthesize editCategoriesButton;
@synthesize showMapButton;
@synthesize AllCategoriesTableView;
@synthesize dataSource = _dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

  
    [self.editCategoriesButton setTarget:self];
    [self.editCategoriesButton setAction:@selector(editCategories)];
    self.editCategoriesButton.enabled = NO;
   


    [self.showMapButton setTarget:self];
    [self.showMapButton setAction:@selector(showMap)];
    self.showMapButton.enabled = YES;
    
}

- (void)showMap
{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)editCategories
{

    if ( [self.dataSource totalNumberOfPlaces] > 0 && self.editCategoriesButton.tag == 1 ) {
        
        [self.AllCategoriesTableView setEditing:YES 
         
                                       animated:YES];
        self.editCategoriesButton.tag = -1;
    }else{
        
        [self.AllCategoriesTableView setEditing:NO 
                                       animated:YES];
        self.editCategoriesButton.tag = 1;
    }
}

- (void)viewDidUnload
{
    [self setEditCategoriesButton:nil];
    [self setShowMapButton:nil];
    [self setAllCategoriesTableView:nil];
   
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.dataSource = [[DataSource alloc] init];
    
    if ([self.dataSource totalNumberOfPlaces] > 0  ) {
    
        self.editCategoriesButton.enabled = YES;
        self.editCategoriesButton.tag = 1;
    
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.dataSource totalNumberOfCategories];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    int numberOfrows = 0;
    
    numberOfrows = [self.dataSource totalNumberOfPlacesOfACategoryAtIndex:section];

    return numberOfrows;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionHeader;
    
    sectionHeader =[self.dataSource.categoryNames objectAtIndex:section];
    return sectionHeader;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString * categoryName =  [self.dataSource.categoryNames objectAtIndex:indexPath.section];
  
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        [self.dataSource removePlaceDetailsInACategory:categoryName AtcategoryDetailIndex:indexPath.row];
        
    }

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if ([self.dataSource totalNumberOfPlaces]  == 0 ) {
        
        self.editCategoriesButton.enabled = NO;
    
    }
   

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
        
    UITableViewCell *cell;
    
    NSString *category;
    NSString *placeName;

    category = [self.dataSource.categoryNames objectAtIndex:indexPath.section ];
    
    placeName = [self.dataSource placeNameOfACategory:category AtcategoryDetailIndex:indexPath.row];
    
    NSString *cellIdentifier = category;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell== nil) {
         cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text = placeName;
    
    return cell;
}

@end
