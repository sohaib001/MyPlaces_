//
//  ModelHandler.m
//  MyPlaces_
//
//  Created by uraan on 11/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataSource.h"
@interface DataSource ()

- (void)makePlistFile;
- (void) addCategoryNamesFromDictionaryToArray;

@end

@implementation DataSource

@synthesize plistLocation = _plistLocation;
@synthesize categoryNames = _categoryNames;
@synthesize plistDictionary = _plistDictionary;



- (id) init{
    self = [super init];
    if (self!=nil) {
        [self makePlistFile];
        self.plistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:self.plistLocation];
    
//    [self addANewCategory:@"MY WORK PLACE"];
//    [self addANewCategory:@"MY BARBER SHOP"];
//    [self addANewCategory:@"MY SHOPPING MALL"];
//      
//        
        [self addCategoryNamesFromDictionaryToArray];
        
        
    }
    return self;
}


- (void)addCategoryNamesFromDictionaryToArray{
    
    self.categoryNames = [[NSMutableArray alloc ] initWithCapacity:[self totalNumberOfCategories]]; 
    [self.plistDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.categoryNames addObject:key];
    } ];
}

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


- (void) addANewCategory:(NSString *) category{

    [self.plistDictionary setObject:[NSMutableArray arrayWithObjects:nil]forKey:category];
    [self.plistDictionary writeToFile:self.plistLocation atomically:YES];
}

- (void) removeACateogry:(NSString *) cateogry{
    
}
- (NSDictionary *) detailsOfAPlaceNameAtCoordinate:(CLLocationCoordinate2D )coordinate inACategory:(NSString *)category{
    
    __block NSDictionary *details;
    NSMutableArray *categoryDetails;
    
    categoryDetails = [self.plistDictionary objectForKey:category];
    
   [ categoryDetails enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
       CLLocationCoordinate2D currentCoordinate;
       
       NSNumber * latitude ;
       NSNumber * longitude;
       
      
       details = obj ;
       
      
       
       latitude = [details objectForKey:@"Latitude"];
       longitude =[details objectForKey:@"Logitude"];
       currentCoordinate.longitude = [longitude  doubleValue];
       currentCoordinate.latitude = [latitude doubleValue];
       if (coordinate.latitude == currentCoordinate.latitude && coordinate.longitude == currentCoordinate.longitude ){
           
           *stop = YES;
           
       }
       
    
    } ];
    return details;
    
}


- (NSUInteger )indexOfAPlaceNameAtCoordinate:(CLLocationCoordinate2D )coordinate inACategory:(NSString *)category{
    
    __block NSUInteger index;
    NSMutableArray *categoryDetails;
    
    categoryDetails = [self.plistDictionary objectForKey:category];
    
    [ categoryDetails enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CLLocationCoordinate2D currentCoordinate;
        
        NSNumber * latitude ;
        NSNumber * longitude;
        
        
       index = idx ;
        
        
        
        latitude = [obj objectForKey:@"Latitude"];
        longitude =[obj objectForKey:@"Logitude"];
        currentCoordinate.longitude = [longitude  doubleValue];
        currentCoordinate.latitude = [latitude doubleValue];
        if (coordinate.latitude == currentCoordinate.latitude && coordinate.longitude == currentCoordinate.longitude ){
            
            *stop = YES;
            
        }
        
        
    } ];
    return index;
    
}

- (void) addPlaceDetails:(NSDictionary *)details InACategory:(NSString *)category{
    
    
    NSMutableArray *categoryDetails;
    
    categoryDetails = [self.plistDictionary objectForKey:category];
    
    
    [categoryDetails addObject:details];
    
    [self.plistDictionary setObject:categoryDetails forKey:category];
    
    
    BOOL fileSuccessfullyWritten = NO;
    
    fileSuccessfullyWritten = [self.plistDictionary writeToFile:self.plistLocation atomically:YES];
    if (!fileSuccessfullyWritten) {
        NSLog(@"%s", "fileNotWrittenSuccessfully");
    } 
 
}


- (void)removePlaceDetailsInACategory:(NSString *)category AtcategoryDetailIndex:(NSUInteger) index
{

    NSMutableArray * categoryDetails ;
    
    categoryDetails = [self listOfPlacesOfACategory:category];
    
    [categoryDetails removeObjectAtIndex:index];
    
    [self.plistDictionary setObject:categoryDetails forKey:category];
    BOOL fileSuccessfullyWritten = NO;
    
    fileSuccessfullyWritten = [self.plistDictionary writeToFile:self.plistLocation atomically:YES];
    if (!fileSuccessfullyWritten) {
        NSLog(@"%s", "fileNotWrittenSuccessfully");
    } 
    
}

- (void)editPlaceDetails:(NSMutableDictionary *)details withUpdateCategory:(NSString *)updateCategory{
    
    
    
    NSString *previousCategory;
    
    previousCategory = [details objectForKey:@"Previous Category"];
    
    NSUInteger placeDetailIndex;
    
    placeDetailIndex = [[details objectForKey:@"PlaceDetailsIndex"] unsignedIntegerValue];
   
    [self removePlaceDetailsInACategory:previousCategory AtcategoryDetailIndex:placeDetailIndex];
        
    [details removeObjectForKey:@"Previous Category"];
    [details removeObjectForKey:@"PlaceDetailsIndex"];
    
    [self addPlaceDetails:details InACategory:updateCategory];
    

}

- (NSString *) placeNameOfACategory:(NSString *)category AtcategoryDetailIndex:(NSUInteger) index{
    
    NSString * placeName;

    NSMutableArray *categoryDetails;
    
    categoryDetails = [self.plistDictionary objectForKey:category];
    
    NSDictionary *details = [categoryDetails objectAtIndex:index];
    placeName = [details objectForKey:@"Place Name"];
    
    
    return placeName;
}


- (NSDictionary *) listOfCategories{
    
    return  self.plistDictionary;
}

- (NSMutableArray *)listOfPlacesOfACategory:(NSString *)category{
    
    
    NSMutableArray *categoryDetails;
    
    categoryDetails = [self.plistDictionary objectForKey:category];
    
    
    return categoryDetails;
}


- (NSUInteger)totalNumberOfCategories{
    
    NSUInteger totalNumberOfCategories = 0;
    
    NSDictionary* categories; 
    
    categories = [self listOfCategories];
    
    totalNumberOfCategories = categories.count;
    
    return totalNumberOfCategories;
}

- (NSUInteger)totalNumberOfPlaces{
    
    
    NSUInteger totalNumberOfPlaces = 0;
    
    NSMutableArray *categoryNames = [self categoryNames];
    NSArray *categoryDetails;

    for ( int categoryNamesIndex = 0; categoryNamesIndex <categoryNames.count; categoryNamesIndex ++) {
        
        categoryDetails = [self listOfPlacesOfACategory:[categoryNames objectAtIndex:categoryNamesIndex]];
         totalNumberOfPlaces = totalNumberOfPlaces + categoryDetails.count;
    }
    
   
    
    return totalNumberOfPlaces;
}


- (NSUInteger)totalNumberOfPlacesOfACategory:(NSString *)category{
   
    NSUInteger totalNumberOfPlaces = 0;

    NSArray *categoryDetails;
    
    categoryDetails = [self listOfPlacesOfACategory:category];
    
    totalNumberOfPlaces = categoryDetails.count;

    return totalNumberOfPlaces;
}

- (NSUInteger)totalNumberOfPlacesOfACategoryAtIndex:(NSUInteger)index{
    
    NSUInteger totalNumberOfPlaces = 0;
    
    
    
    NSString *categoryName = [self.categoryNames objectAtIndex:index];
    
    NSArray *categoryDetails;
    
    categoryDetails = [self listOfPlacesOfACategory:categoryName];
    
    totalNumberOfPlaces = categoryDetails.count;
    
    return totalNumberOfPlaces;

}




- (void)dealloc{
    
    [self setPlistLocation:nil];
}




@end
