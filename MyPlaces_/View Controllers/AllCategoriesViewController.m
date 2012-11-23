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
    self.editCategoriesButton.enabled = YES;


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

    if (self.AllCategoriesTableView.editing) {
        
        [self.AllCategoriesTableView setEditing:NO 
                                       animated:YES];
    }else{
        
        [self.AllCategoriesTableView setEditing:YES 
                                       animated:YES];
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

/*
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
*/
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

/*
#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
    categoryViewController.delegate =self;
    categoryViewController.placeInfo = self.placeInfo;
    if (indexPath.row == 1 && indexPath.section == 0) {
        [self.navigationController pushViewController:categoryViewController animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 && indexPath.section == 1 ) {
        return 159;
    }else{
        return 44;
    }
}


*/


@end
