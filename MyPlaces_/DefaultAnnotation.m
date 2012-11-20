//
//  DefaultAnnotation.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DefaultAnnotation.h"

@implementation DefaultAnnotation
@synthesize coordinates = _coordinates;
@synthesize annotationTitle = annotationTitle;


-(CLLocationCoordinate2D)coordinate{
    return self.coordinates;
}
-(NSString *)title{
    
    return self.annotationTitle;
        
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.coordinates = newCoordinate;
}
@end
