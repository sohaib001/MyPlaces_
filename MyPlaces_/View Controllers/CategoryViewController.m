//
//  CategoryViewController.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "DataSource.h"
@interface  CategoryViewController()

@property (strong, nonatomic) DataSource *dataSource;

@end


@implementation CategoryViewController

@synthesize placeInfo = _placeInfo;
@synthesize selectedCategory = _selectedCategory;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize chooseCategoryPickerView;

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
    self.dataSource = [[DataSource alloc] init];

}

- (void)viewDidUnload
{
    
    [self setChooseCategoryPickerView:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
  
    [self setDelegate:nil];
    [self setSelectedCategory:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
     
    
    [self.chooseCategoryPickerView selectRow:[[self.dataSource categoryNames] indexOfObject:self.placeInfo.category] inComponent:0 animated:YES];
      self.selectedCategory = [[self.dataSource categoryNames] objectAtIndex:0];

}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.delegate didCategorySelect:self.selectedCategory];

}

#pragma mark - UIPickerViewDelegate


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.selectedCategory = [[self.dataSource categoryNames] objectAtIndex:row];
    
}

#pragma mark - VIPickerViewDetaSource

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [[self.dataSource categoryNames] count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.dataSource categoryNames] objectAtIndex:row];
}


@end
