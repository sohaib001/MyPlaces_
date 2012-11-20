//
//  MapViewController.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MapViewController.h"
#import "DetailsViewController.h"
#import "SelectCategoryViewController.h"


@interface MapViewController() 

- (void)addAnnotationButton;    
- (void)addDetails;
- (BOOL)isCategorySelected;
- (void) showPlacesOfSelectedCategory;
@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize selectCategory = _selectCategory;
@synthesize deselectCategory = _deselectCategory;
@synthesize placeInfo = _placeInfo;
@synthesize model = _model;
@synthesize selectedCategory = _selectedCategory;
@synthesize defaultAnnotation = _defaultAnnotation;

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
    [self addAnnotationButton];
}




- (void)viewDidUnload
{
    [self setPlaceInfo:nil];
    [self setMapView:nil];
    [self setSelectCategory:nil];
    [self setDeselectCategory:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.placeInfo = [[PlaceInfo alloc] init];
    self.mapView.showsUserLocation = YES;  
    if (self.isCategorySelected) {
        
        [self showPlacesOfSelectedCategory];
    } 
}
- (void)dealloc
{
    [self setPlaceInfo:nil];
   
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)addAnnotationButton
{
 //   [self.mapView removeAnnotation:self.mapView.annotations.lastObject];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDefaultAnnotation)];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(removeDefaultAnnotation)];
     self.navigationItem.leftBarButtonItem.enabled =NO;
}

- (void)addDefaultAnnotation{
 
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    CLLocationCoordinate2D currentLocationCoordinates;
    
    currentLocationCoordinates = [[self.mapView userLocation]  coordinate];
    
    self.placeInfo.Coordinate = currentLocationCoordinates;
    
    self.defaultAnnotation = [[DefaultAnnotation alloc] init];
    [self.defaultAnnotation setAnnotationTitle:@"Add Details"];
    [self.defaultAnnotation setCoordinates:currentLocationCoordinates];
    [self.mapView addAnnotation:self.defaultAnnotation];
    
}
- (void)removeDefaultAnnotation{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self.mapView removeAnnotation:self.defaultAnnotation];
}

#pragma mark - MapViewController

- (void)addDetails
{
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    
    detailsViewController.placeInfo = self.placeInfo;
  
    self.selectedCategory = nil;
    [self.navigationController pushViewController:detailsViewController animated:YES];;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CGPoint dropPoint = CGPointMake(view.center.x, view.center.y);
        
        CLLocationCoordinate2D newCoordinate = [self.mapView 
                                                convertPoint:dropPoint 
                                                toCoordinateFromView:view.superview];
        
        self.placeInfo.Coordinate = newCoordinate;
        
        [view.annotation setCoordinate:newCoordinate];
        
        
    }    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
   
    MKPinAnnotationView *customPinView;
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        
        return nil;
    } 
    
    else if ([annotation isKindOfClass:[SelectedCategoryAnnotation class]]) 
    {
        static NSString *reuseId = @"SelectedCategoryAnnotationPin";
        customPinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (customPinView == nil)
        {
            customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            customPinView.canShowCallout = YES;
            customPinView.pinColor = MKPinAnnotationColorPurple;
        }
        else
        {
            customPinView.annotation = annotation;
        }

        
    }
    else
    {
        static NSString *reuseId = @"pin";
      customPinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (customPinView == nil)
        {
            customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            customPinView.draggable = YES;
            customPinView.canShowCallout = YES;
        }
        else
        {
            customPinView.annotation = annotation;
        }

        
    }
       
    customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
      
    return  customPinView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self addDetails];
}




- (IBAction)didSelectCategoryTapped
{
    SelectCategoryViewController *selectCategory = [[SelectCategoryViewController alloc] init];
    selectCategory.delegate=self;
    if (!self.navigationItem.rightBarButtonItem.enabled) {
        [self.mapView removeAnnotation:self.defaultAnnotation];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    [self.navigationController pushViewController:selectCategory animated:NO];
    
}
- (IBAction)didDeselectCategoryTapped
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    if (!self.navigationItem.rightBarButtonItem.enabled) {
       
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    
}


#pragma mark - CategoryDelegate

-(void)didCategorySelect:(NSString *)categroy{
    
    self.selectedCategory = categroy;
   
}

- (BOOL)isCategorySelected{
        
    BOOL result = NO;
    
    if (self.selectedCategory!=nil ) {
        
        result =YES;
    }
    return result;

}
- (void) showPlacesOfSelectedCategory{
    
    ModelHandler *model = [[ModelHandler alloc] init];
    [model makePlistFile];
    NSArray * categoryDetails;
    categoryDetails = [model listOfPlacesOfACategory:self.selectedCategory];
    
    for (NSDictionary * detail in categoryDetails) {
        
        
        NSString * placeName =[detail objectForKey:@"Place Name"];
        
        CLLocationCoordinate2D  currentLocationCoordinates;
        currentLocationCoordinates.latitude =
        [[detail objectForKey:@"Latitude"] doubleValue];
        currentLocationCoordinates.longitude =
        [[detail objectForKey:@"Logitude"] doubleValue]; 
        
        SelectedCategoryAnnotation *annotation = [[SelectedCategoryAnnotation alloc] init];
        [annotation setAnnotationTitle:placeName];
        [annotation setCoordinates:currentLocationCoordinates];
        [self.mapView addAnnotation:annotation];
    }
    
}


@end
