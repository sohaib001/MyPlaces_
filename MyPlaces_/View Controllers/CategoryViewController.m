//
//  CategoryViewController.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"

@interface  CategoryViewController()


- (void)addCategories;

@end


@implementation CategoryViewController
@synthesize placeInfo = _placeInfo;
@synthesize selectedCategory = _selectedCategory;
@synthesize delegate = _delegate;
@synthesize chooseCategoryPickerView;
@synthesize categories = _categories;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addCategories];
    
}

- (void)viewDidUnload
{
    [self setChooseCategoryPickerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
  
    [self setDelegate:nil];
    [self setCategories:nil];
    [self setSelectedCategory:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.chooseCategoryPickerView selectRow:[self.categories indexOfObject:self.placeInfo.category ]inComponent:0 animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.delegate didCategorySelect:self.selectedCategory];
}

- (void)addCategories
{
    self.categories = [[NSMutableArray alloc] initWithCapacity:3];
    [self.categories addObject:@"My Shopping Mall"];
    [self.categories addObject:@"My Barber Shop"];
    [self.categories addObject:@"My Work Place"];
    self.selectedCategory = [self.categories objectAtIndex:0];
  
}


#pragma mark - UIPickerViewDelegate


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.selectedCategory = [self.categories objectAtIndex:row];
    
}

#pragma mark - VIPickerViewDetaSource

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.categories.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.categories objectAtIndex:row];
}


@end
