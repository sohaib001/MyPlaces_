//
//  MapViewController.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MapViewController.h"
#import "DetailsViewController.h"
#import "AllCategoriesViewController.h"
#import "PlaceInfo.h"
#import "DefaultAnnotation.h"
#import "SelectedCategoryAnnotation.h"
#import "DataSource.h"


@interface MapViewController() 


@property (strong, nonatomic) DataSource *dataSource;
@property (strong, nonatomic) PlaceInfo *placeInfo;
@property (strong, nonatomic)  UIActionSheet *categoryActionSheet; 
@property (strong, nonatomic) NSString * categoryToShowPlaceOnMap;


- (void)addDetails;
- (void)showPlacesOfSelectedCategory;
- (void)makeCategorySelectionView;

@end

@implementation MapViewController

@synthesize dataSource = _dataSource;
@synthesize categoryActionSheet = _categoryActionSheet;
@synthesize arrowImageView = _arrowImageView;
@synthesize menuBarView = _menuBarView;
@synthesize mapView = _mapView;
@synthesize placeInfo = _placeInfo;
@synthesize categoryToShowPlaceOnMap = _categoryToShowPlaceOnMap;
@synthesize defaultAnnotation = _defaultAnnotation;


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
    
    
    [self makeCategorySelectionView];
   
    
    
    UIBarButtonItem *showAllCategoriesButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showAllCategories:)];
    [self.navigationItem setRightBarButtonItem:showAllCategoriesButton];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    // longPressGesture for the default Annotation
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] 
                                                      initWithTarget:self 
                                                      action:@selector(handleLongPressGesture:)];
    longPressGesture.minimumPressDuration = .5f;
    [self.mapView addGestureRecognizer:longPressGesture];
 
    
    
    // tapGesture for showing menu bar
    UITapGestureRecognizer *leftTapRecognizer = [[ UITapGestureRecognizer alloc] 
                                                 initWithTarget:self 
                                                 action:@selector(didArrowTap)];
    [self.arrowImageView addGestureRecognizer:leftTapRecognizer];
    
    
}



- (void)showAllCategories:(id)sender{
    
    AllCategoriesViewController *allCategoriesController =[[AllCategoriesViewController alloc] init];  
    allCategoriesController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;  
  
    [self presentModalViewController:allCategoriesController animated:YES];
  
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        
    }else{
       
        if (self.defaultAnnotation !=nil)
        {
       
            CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
            CLLocationCoordinate2D touchMapCoordinate = 
            [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
           
            [self.mapView removeAnnotation:self.defaultAnnotation];
            
            [self.defaultAnnotation setCoordinates:touchMapCoordinate];
            
            [self.mapView addAnnotation:self.defaultAnnotation];
        }
    }
}

- (void) didArrowTap{
    
    CGRect menuBarFrame=self.menuBarView.frame;
    menuBarFrame.origin.x = 0;
    
    CGRect arrowImageViewFrame = self.arrowImageView.frame;
    arrowImageViewFrame.origin.x = 320;
    
    [UIView animateWithDuration:.5f delay:.5f options:UIViewAnimationOptionCurveLinear animations:^{
   
        [self.menuBarView setFrame:menuBarFrame];
        [self.arrowImageView setFrame:arrowImageViewFrame];
    }completion:nil ];
    
    
}


- (void)viewDidUnload
{
    [self setPlaceInfo:nil];
    [self setMapView:nil];
    [self setArrowImageView:nil];
    [self setMenuBarView:nil];
    
    [super viewDidUnload];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    self.placeInfo = [[PlaceInfo alloc] init];
    self.mapView.showsUserLocation = YES;  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}

- (void)dealloc
{
    
    [self setPlaceInfo:nil];
    
}


#pragma mark - MapViewController

- (void)addDetails
{
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    
    detailsViewController.placeInfo = self.placeInfo;
  
    self.categoryToShowPlaceOnMap = nil;
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


- (void) showPlacesOfSelectedCategory{
    
    
   
    NSArray * categoryDetails;
    categoryDetails = [self.dataSource listOfPlacesOfACategory:self.categoryToShowPlaceOnMap];
    
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


- (IBAction)addDefaultAnnotation:(UIButton *)sender {
    
    
        
        CLLocationCoordinate2D currentLocationCoordinates;
        
        currentLocationCoordinates = [[self.mapView userLocation]  coordinate];
        
        self.placeInfo.Coordinate = currentLocationCoordinates;
    
        if (self.defaultAnnotation == nil) {
            
            self.defaultAnnotation = [[DefaultAnnotation alloc] init];
            self.defaultAnnotation.annotationTitle = @"Add Details";
        }
        
        [self.defaultAnnotation setCoordinates:currentLocationCoordinates];
        
        [self.mapView addAnnotation:self.defaultAnnotation];
    
    sender.userInteractionEnabled = NO;
     
    
   
      
    

}



- (void) makeCategorySelectionView{
    
    self.categoryActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Category" 
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
    self.categoryActionSheet.delegate = self;
    
}


- (IBAction)didSelectCategoryTapped:(UIButton *)sender
{
    
    [self.categoryActionSheet showInView:self.view];
    [self.categoryActionSheet setFrame:CGRectMake(0, 100, 320, 320)];
}


#pragma mark - UIActionSheetDelegate

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    UIPickerView *categoryPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20,70,280,0)];
    categoryPickerView.delegate = self;
    categoryPickerView.showsSelectionIndicator = YES;
    
    [self.categoryActionSheet addSubview:categoryPickerView];
   
    
    UIToolbar * actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(20, 40, 280, 30)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(actionCancel)];
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(actionOK)];
    UIBarButtonItem *flexibleSpace =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [actionToolbar setItems:[NSArray arrayWithObjects:cancelButton,flexibleSpace,okButton, nil] animated:YES];
       
    [self.categoryActionSheet addSubview:actionToolbar];

}

- (void)actionCancel{
     [self.categoryActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)actionOK{
    [self showPlacesOfSelectedCategory];
    [self.categoryActionSheet dismissWithClickedButtonIndex:0 animated:YES];
   
}


#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSArray * categoryNames ;
    categoryNames = [self.dataSource categoryNames];

    return  [categoryNames objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSArray * categoryNames ;
    categoryNames = [self.dataSource categoryNames];
    
    self.categoryToShowPlaceOnMap = [categoryNames objectAtIndex:row];
    
    
}


#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;

}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSUInteger numberOfRows = 0;
    numberOfRows = [self.dataSource totalNumberOfCategories];
    
    return numberOfRows;
}

@end
