//
//  Place.h
//  MyPlaces_
//
//  Created by uraan on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceInfo : NSObject


@property (strong, nonatomic) NSString *placeName;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *comment;
@property  NSUInteger identifier ;
@property CLLocationCoordinate2D Coordinate;
@property (strong, nonatomic) NSString *previousCategory;
@end
