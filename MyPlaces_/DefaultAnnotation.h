//
//  DefaultAnnotation.h
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface DefaultAnnotation : NSObject <MKAnnotation>

@property CLLocationCoordinate2D coordinates;

@end
