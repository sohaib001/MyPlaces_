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


-(CLLocationCoordinate2D)coordinate{
    return self.coordinates;
}
-(NSString *)title{
    return @"Add Details";
}

@end
