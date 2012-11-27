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
@property (strong, nonatomic) NSString *categoryToShowPlaceOnMap;
@property (strong, nonatomic) NSMutableArray *alreadySelectedCategoryToShowPlaceOnMap;

- (void)addDetails;
- (void)editDetails;
- (void)showPlacesOfSelectedCategory;
- (void)makeCategorySelectionView;
- (void)addAnnotationsToSelectedCategoryToShowPlacesOnMap;
- (BOOL)isSelectedCategoryToShowPlacesOnMap;
- (void)addToolbarOnCategoryActionSheet;
- (void)removeAlreadySelectedCategoryAnnotations;
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
@synthesize alreadySelectedCategoryToShowPlaceOnMap = _alreadySelectedCategoryToShowPlaceOnMap;

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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.alreadySelectedCategoryToShowPlaceOnMap = nil ;
    self.categoryToShowPlaceOnMap = nil;                                               
}


- (void)showAllCategories:(id)sender{
    [self removeAlreadySelectedCategoryAnnotations];
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
        
            self.placeInfo.Coordinate = touchMapCoordinate;
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
    self.dataSource = [[DataSource alloc] init];
    self.mapView.showsUserLocation = YES; 
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}

- (void)dealloc
{
    
    [self setPlaceInfo:nil];
    [self setCategoryActionSheet:nil];
}


#pragma mark - MapViewController

- (void)addDetails
{
    
    [self removeAlreadySelectedCategoryAnnotations];
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    
    detailsViewController.placeInfo = self.placeInfo;
  
    
    
    [self.navigationController pushViewController:detailsViewController animated:YES];;
}

- (void)editDetails
{
    [self removeAlreadySelectedCategoryAnnotations];
    DetailsViewController *editDetailsViewController = [[DetailsViewController alloc] init];
    
    editDetailsViewController.delegate = self;
    [self isEditingEnabled];

    editDetailsViewController.placeInfo = self.placeInfo;
    
 
    
    [self.navigationController pushViewController:editDetailsViewController animated:YES];;
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

        customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        customPinView.rightCalloutAccessoryView.tag = 2; 
    }
    else
    {
        static NSString *DefaultAnnotationId = @"DefaultAnnotationPin";
      customPinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:DefaultAnnotationId];
        
        if (customPinView == nil){
        
            customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:DefaultAnnotationId];
            customPinView.draggable = YES;
            customPinView.canShowCallout = YES;
        
        }else
        {
            customPinView.annotation = annotation;
           
        }

        customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        customPinView.rightCalloutAccessoryView.tag = 1; 
 
    }
       
    
    
    return  customPinView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    
    if (view.rightCalloutAccessoryView.tag == 1) {
       
        [self addDetails];
    }
    else if (view.rightCalloutAccessoryView.tag == 2){
        
        
        CLLocationCoordinate2D  coordinate;
        coordinate = [view.annotation coordinate];
        
        int index =[[mapView annotations] indexOfObject:view.annotation];
        
        SelectedCategoryAnnotation *annotation =[[mapView annotations] objectAtIndex:index];
        
        NSDictionary *details;
        details =[self.dataSource detailsOfAPlaceNameAtCoordinate:coordinate inACategory:annotation.annotationCategory];
    
        self.placeInfo.placeName = [details objectForKey:@"Place Name"];
        self.placeInfo.comment = [details objectForKey:@"Comments"];
        self.placeInfo.Coordinate = coordinate;
        self.placeInfo.category = annotation.annotationCategory;
        self.placeInfo.previousCategory = annotation.annotationCategory;
        self.placeInfo.identifier =  [self.dataSource indexOfAPlaceNameAtCoordinate:coordinate inACategory:annotation.annotationCategory];
        
        [self editDetails];
    }

    
}


- (void)showPlacesOfSelectedCategory{
    if (self.alreadySelectedCategoryToShowPlaceOnMap == nil){
        self.alreadySelectedCategoryToShowPlaceOnMap = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
      
        if (!self.isSelectedCategoryToShowPlacesOnMap && [self.dataSource totalNumberOfPlacesOfACategory:self.categoryToShowPlaceOnMap] > 0) {
            
            [self.alreadySelectedCategoryToShowPlaceOnMap addObject:self.categoryToShowPlaceOnMap];
            [self addAnnotationsToSelectedCategoryToShowPlacesOnMap];
        } 
        
       

}

- (BOOL)isSelectedCategoryToShowPlacesOnMap{
    
    __block BOOL result = NO;
    
    [self.alreadySelectedCategoryToShowPlaceOnMap enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:self.categoryToShowPlaceOnMap]) {
            result = YES;
            *stop = YES;
        }
    } ];
    
    return result;
}
- (void) addAnnotationsToSelectedCategoryToShowPlacesOnMap{
   
    NSArray * categoryDetails;
    categoryDetails = [self.dataSource listOfPlacesOfACategory:self.categoryToShowPlaceOnMap];
    
    [categoryDetails enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSString * placeName =[obj objectForKey:@"Place Name"];
        
        CLLocationCoordinate2D  currentLocationCoordinates;
        currentLocationCoordinates.latitude = 
        [[obj objectForKey:@"Latitude"] doubleValue];
        currentLocationCoordinates.longitude =
        [[obj objectForKey:@"Logitude"] doubleValue]; 
        
        SelectedCategoryAnnotation *annotation = [[SelectedCategoryAnnotation alloc] init];
        [annotation setAnnotationTitle:placeName];
        [annotation setCoordinates:currentLocationCoordinates];
        [annotation setAnnotationCategory:self.categoryToShowPlaceOnMap];
        [self.mapView addAnnotation:annotation];
    }];

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
    
    self.categoryActionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
    self.categoryActionSheet.delegate = self;
    
}


- (IBAction)didSelectCategoryTapped:(UIButton *)sender
{
    [self makeCategorySelectionView];
    [self.categoryActionSheet showInView:self.view];
    [self.categoryActionSheet setFrame:CGRectMake(0, 156, 320, 260)];
    [self addToolbarOnCategoryActionSheet];
    
}

- (void)addToolbarOnCategoryActionSheet{
    
    UIToolbar * actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(actionCancel)];
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(actionOK)];
    UIBarButtonItem *flexibleSpace =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [actionToolbar setItems:[NSArray arrayWithObjects:cancelButton,flexibleSpace,okButton, nil] animated:YES];
    [self.categoryActionSheet addSubview:actionToolbar];
}

#pragma mark - UIActionSheetDelegate

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    
    UIPickerView *categoryPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20,35,280,0)];
    categoryPickerView.delegate = self;
    categoryPickerView.showsSelectionIndicator = YES;
    
    [self.categoryActionSheet addSubview:categoryPickerView];
}

- (void)actionCancel
{
  
     [self.categoryActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)actionOK
{
    NSArray *categoryActionSheetSubViews;
    
    categoryActionSheetSubViews = [self.categoryActionSheet subviews];
    
    NSInteger row = [[categoryActionSheetSubViews objectAtIndex:0] selectedRowInComponent:0];
    
    NSArray * categoryNames ;
    
    categoryNames = [self.dataSource categoryNames];
    self.categoryToShowPlaceOnMap = [categoryNames objectAtIndex:row];
   
    [self showPlacesOfSelectedCategory];
    [self.categoryActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSArray * categoryNames ;
    categoryNames = [self.dataSource categoryNames];

    return  [categoryNames objectAtIndex:row];
    
}


#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;

}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    NSUInteger numberOfRows = 0;
    
    numberOfRows = [self.dataSource totalNumberOfCategories];
    
    return numberOfRows;
}
#pragma mark - DetailsViewControllerDelegate

-(BOOL)isEditingEnabled{
    return YES;
}



- (void)removeAlreadySelectedCategoryAnnotations{
    
    NSArray *allAnnotations;
    allAnnotations = [self.mapView annotations];
    
    [allAnnotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[SelectedCategoryAnnotation class]]){
            [self.mapView removeAnnotation:obj];
        }
    }];
}
@end
