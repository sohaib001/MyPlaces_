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
        [self addCategoryNamesFromDictionaryToArray];
        
        
    }
    return self;
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


- (void) removePlaceDetailsInACategory:(NSString *)category{
    
}

- (NSDictionary *) listOfCategories{

    return  self.plistDictionary;
}

- (NSUInteger) totalNumberOfCategories{
    
    NSUInteger totalNumberOfCategories = 0;
    
    NSDictionary* categories; 
    
    categories = [self listOfCategories];
    
    totalNumberOfCategories = categories.count;
    
    return totalNumberOfCategories;
}



- (NSArray *)listOfPlacesOfACategory:(NSString *)category{
    
        
    NSMutableArray *categoryDetails;
    
    categoryDetails = [self.plistDictionary objectForKey:category];
    
    
    return categoryDetails;
}


- (NSString *) placeNameOfACategory:(NSString *) category AtcategoryDetailIndex:(NSUInteger) index{
    
    NSString * placeName;

    NSMutableArray *categoryDetails;
    
    categoryDetails = [self.plistDictionary objectForKey:category];
    
    NSDictionary *details = [categoryDetails objectAtIndex:index];
   placeName = [details objectForKey:@"Place Name"];
    
    
    return placeName;
}


- (NSUInteger ) totalNumberOfPlacesOfACategory:(NSString *)category{
   
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



- (void) addCategoryNamesFromDictionaryToArray{
   
    self.categoryNames = [[NSMutableArray alloc ] initWithCapacity:[self totalNumberOfCategories]]; 
    [self.plistDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.categoryNames addObject:key];
   } ];
}



- (void)dealloc{
    
    [self setPlistLocation:nil];
}




@end
