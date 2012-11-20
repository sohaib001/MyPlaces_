//
//  ModelHandler.m
//  MyPlaces_
//
//  Created by uraan on 11/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelHandler.h"

@implementation ModelHandler

@synthesize plistLocation = _plistLocation;

- (void)makePlistFile{
    
    
    NSError *err;
    
     NSFileManager *fileManager = [NSFileManager defaultManager];
    self.plistLocation = [[NSString alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    self.plistLocation = [documentDirectory stringByAppendingPathComponent:@"Details.plist"];
    
    if(![fileManager fileExistsAtPath:self.plistLocation])
    {
        NSString *correctPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Details.plist"];
        
        [fileManager copyItemAtPath:correctPath toPath:self.plistLocation error:&err];      
    }
    
    
}


- (NSArray *) listOfPlacesOfACategory:(NSString *)category{
    
    NSMutableDictionary* plistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:self.plistLocation];
    
    NSMutableArray *categoryDetails;
    
    categoryDetails = [plistDictionary objectForKey:category];
    
    
    return categoryDetails;
}
- (void)dealloc{
  
    [self setPlistLocation:nil];
}




@end
