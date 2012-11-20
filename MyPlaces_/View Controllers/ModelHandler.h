//
//  ModelHandler.h
//  MyPlaces_
//
//  Created by uraan on 11/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelHandler : NSObject

@property (strong, nonatomic) NSString *plistLocation;


-(void)makePlistFile;
- (NSArray *) listOfPlacesOfACategory:(NSString *)category;

@end
