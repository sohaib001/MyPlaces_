//
//  MapViewController.h
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceInfo.h"
@class  AddDetailsViewController;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) PlaceInfo *placeInfo;
@property CLLocationCoordinate2D tappedCoordinate;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) AddDetailsViewController *addDetailsViewController;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@end
