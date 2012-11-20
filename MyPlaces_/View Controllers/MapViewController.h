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
#import "ModelHandler.h"

#import "SelectCategoryViewController.h"

#import "DefaultAnnotation.h"
#import "SelectedCategoryAnnotation.h"


@interface MapViewController : UIViewController <MKMapViewDelegate,CategoryDelegate>

@property (strong, nonatomic) PlaceInfo *placeInfo;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *selectCategory;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *deselectCategory;

@property (strong, nonatomic) ModelHandler * model;
@property (strong, nonatomic) NSString * selectedCategory;

@property (strong, nonatomic) DefaultAnnotation *defaultAnnotation;

- (IBAction) didSelectCategoryTapped;
- (IBAction) didDeselectCategoryTapped;
@end
