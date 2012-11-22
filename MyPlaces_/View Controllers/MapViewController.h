//
//  MapViewController.h
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class DataSource;
@class PlaceInfo;
@class DefaultAnnotation;
@class SelectedCategoryAnnotation;

@interface MapViewController : UIViewController <MKMapViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


@property (strong, nonatomic) IBOutlet MKMapView *mapView;



@property (strong, nonatomic) DefaultAnnotation *defaultAnnotation;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet UIView *menuBarView;

- (IBAction)addDefaultAnnotation:(UIButton *)sender;
- (IBAction)didSelectCategoryTapped:(UIButton *)sender;



@end
