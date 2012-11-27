//
//  ModelHandler.h
//  MyPlaces_
//
//  Created by uraan on 11/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DataSource : NSObject

@property (strong, nonatomic) NSString *plistLocation;
@property (strong , nonatomic) NSMutableArray *categoryNames; 
@property (strong, nonatomic) NSMutableDictionary *plistDictionary;

- (NSDictionary *)listOfCategories;
- (NSMutableArray *)listOfPlacesOfACategory:(NSString *)category;

- (NSUInteger)totalNumberOfCategories;
- (NSUInteger)totalNumberOfPlaces;

- (NSUInteger)totalNumberOfPlacesOfACategory:(NSString *)category;
- (NSUInteger)totalNumberOfPlacesOfACategoryAtIndex:(NSUInteger)index;

- (NSString *)placeNameOfACategory:(NSString *) category AtcategoryDetailIndex:(NSUInteger) index;

- (void)addPlaceDetails:(NSDictionary *)details InACategory:(NSString *)category;
- (void)removePlaceDetailsInACategory:(NSString *)category AtcategoryDetailIndex:(NSUInteger)index;
- (void)editPlaceDetails:(NSMutableDictionary *)details withUpdateCategory:(NSString *)category;

- (NSDictionary *) detailsOfAPlaceNameAtCoordinate :(CLLocationCoordinate2D)coordinate inACategory:(NSString *)category;
- (NSUInteger )indexOfAPlaceNameAtCoordinate:(CLLocationCoordinate2D )coordinate inACategory:(NSString *)category;

- (void)addANewCategory:(NSString *)category;
- (void)removeACateogry:(NSString *)cateogry;

@end
