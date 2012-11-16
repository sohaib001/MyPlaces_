//
//  MapViewController.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MapViewController.h"
#import "DetailsViewController.h"
#import "DefaultAnnotation.h"

@interface MapViewController() 

- (void)addAnnotationButton;    
- (void)addDetails;

@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize placeInfo = _placeInfo;


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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.placeInfo = [[PlaceInfo alloc] init];
    self.mapView.showsUserLocation = YES;  
    
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDefaultAnnotation)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

- (void)addDefaultAnnotation{
 
    self.navigationItem.rightBarButtonItem.enabled =NO;
    
    CLLocationCoordinate2D currentLocationCoordinates;
    
    currentLocationCoordinates = [[self.mapView userLocation]  coordinate];
    
    self.placeInfo.Coordinate = currentLocationCoordinates;
    
    DefaultAnnotation *annotation = [[DefaultAnnotation alloc] init];
    [annotation setCoordinates:currentLocationCoordinates];
    [self.mapView addAnnotation:annotation];
    
}

#pragma mark - MapViewController

- (void)addDetails
{
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    
    detailsViewController.placeInfo = self.placeInfo;
    
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
   
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        
        return nil;
    } 
    
       
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *customPinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
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
   
    customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
      
    return  customPinView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self addDetails];
}

@end
