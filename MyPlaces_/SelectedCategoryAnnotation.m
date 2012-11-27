//
//  SelectedCategoryAnnotation.m
//  MyPlaces_
//
//  Created by uraan on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedCategoryAnnotation.h"

@implementation SelectedCategoryAnnotation

@synthesize coordinates = _coordinates;
@synthesize annotationTitle = _annotationTitle;
@synthesize annotationCategory = _annotationCategory;
-(CLLocationCoordinate2D)coordinate
{

    return self.coordinates;

}
-(NSString *)title
{
    
    return self.annotationTitle;

}

@end
