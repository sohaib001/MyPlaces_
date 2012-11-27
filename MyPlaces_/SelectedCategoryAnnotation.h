//
//  SelectedCategoryAnnotation.h
//  MyPlaces_
//
//  Created by uraan on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface SelectedCategoryAnnotation : NSObject<MKAnnotation>
@property CLLocationCoordinate2D coordinates;
@property (strong, nonatomic) NSString * annotationTitle;
@property (strong, nonatomic) NSString * annotationCategory;
@end
