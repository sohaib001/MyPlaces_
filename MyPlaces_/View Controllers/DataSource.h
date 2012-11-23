//
//  ModelHandler.h
//  MyPlaces_
//
//  Created by uraan on 11/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

@property (strong, nonatomic) NSString *plistLocation;
@property (strong, nonatomic) NSMutableArray *categoryNames;
@property (strong, nonatomic) NSMutableDictionary *plistDictionary;

- (NSArray *)listOfPlacesOfACategory:(NSString *)category;
- (NSDictionary *)listOfCategories;
- (NSUInteger)totalNumberOfCategories;
- (NSUInteger)totalNumberOfPlacesOfACategory:(NSString *)category;
- (NSUInteger)totalNumberOfPlacesOfACategoryAtIndex:(NSUInteger)index;
- (NSString *)placeNameOfACategory:(NSString *) category AtcategoryDetailIndex:(NSUInteger) index;
- (void)addPlaceDetails:(NSDictionary *)details InACategory:(NSString *)category;
- (void)addANewCategory:(NSString *) category;

@end
