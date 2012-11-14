//
//  MapViewController.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "AddDetailsViewController.h"
#import "DefaultAnnotation.h"

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize addDetailsViewController = _addDetailsViewController;
@synthesize tapRecognizer = _tapRecognizer;
@synthesize tappedCoordinate = _tappedCoordinate;
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
    [self.tapRecognizer addTarget:self action:@selector(mapTapped:)];
    
}

- (void)viewDidUnload
{
    [self setPlaceInfo:nil];
    [self setTapRecognizer:nil];
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.placeInfo = [[PlaceInfo alloc] init];
}
- (void)dealloc
{
    
    [self setAddDetailsViewController:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - MapViewController

-(void)mapTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint location=[tapRecognizer locationInView:self.mapView];
    
    self.tappedCoordinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    
    self.placeInfo.Coordinate = self.tappedCoordinate;
    
    DefaultAnnotation *annotation = [[DefaultAnnotation alloc] init];
    
    [annotation setCoordinates:self.tappedCoordinate];
    
   [self.mapView removeAnnotation:[self.mapView.annotations lastObject]];
    
    [self.mapView addAnnotation:annotation];
    
}

- (void)addDetails:(id)sender
{
    self.addDetailsViewController = [[AddDetailsViewController alloc] init];
    self.addDetailsViewController.placeInfo = self.placeInfo;
    

    [self.navigationController pushViewController:self.addDetailsViewController animated:YES];;
}

#pragma mark - MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:nil] ;
    customPinView.pinColor = MKPinAnnotationColorPurple; 
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
//#error see calloutview tapped
    
    customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return  customPinView;
}
-(void)removeAllAnnotations
{
    //Get the current user location annotation.
    id userAnnotation=self.mapView.userLocation;
    
    //Remove all added annotations
    [self.mapView removeAnnotations:self.mapView.annotations]; 
    
    // Add the current user location annotation again.
    if(userAnnotation!=nil)
        [self.mapView addAnnotation:userAnnotation];
}


@end
