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


@interface MapViewController : UIViewController <MKMapViewDelegate>


@property (strong, nonatomic) PlaceInfo *placeInfo;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
