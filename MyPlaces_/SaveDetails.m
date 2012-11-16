//
//  SaveDetails.m
//  MyPlaces_
//
//  Created by uraan on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveDetails.h"

@implementation SaveDetails

@synthesize fileManager = _fileManager;
@synthesize plistLocation = _plistLocation;

- (void)makePlistFileWithName:(NSString *)pListName{
   
    
    NSError *err;
    
    self.fileManager = [NSFileManager defaultManager];
    self.plistLocation = [[NSString alloc] init];
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    self.plistLocation = [documentDirectory stringByAppendingPathComponent:pListName];
    
    if(![self.fileManager fileExistsAtPath:self.plistLocation])
    {
        NSString *correctPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pListName];
    
        [self.fileManager copyItemAtPath:correctPath toPath:self.plistLocation error:&err];      
    }
    
    
}

- (void)saveDetailsInDictionary:(NSDictionary *) details forKey:(NSString *) key{
    
    
    NSMutableDictionary* plistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:self.plistLocation];
    
    
    
    if ([plistDictionary count] == 0 ) {
        
        [plistDictionary setObject:[NSMutableArray arrayWithObjects:nil] forKey:@"My Work Place"];
        [plistDictionary setObject:[NSMutableArray arrayWithObjects:nil] forKey:@"My Barber Shop"];
        [plistDictionary setObject:[NSMutableArray arrayWithObjects:nil] forKey:@"My Shopping Mall"];
        [plistDictionary writeToFile:self.plistLocation atomically:YES];
    }
      
    NSMutableArray *categoryDetails;
    
    categoryDetails = [plistDictionary objectForKey:key];
    
   
    [categoryDetails addObject:details];
    
    [plistDictionary setObject:categoryDetails forKey:key];
    
    
    BOOL fileSuccessfullyWritten = NO;
    
    fileSuccessfullyWritten = [plistDictionary writeToFile:self.plistLocation atomically:YES];
    if (!fileSuccessfullyWritten) {
        NSLog(@"%s", "fileNotWrittenSuccessfully");
    } 
   
}




- (void)dealloc{
    [self setFileManager:nil];
    [self setPlistLocation:nil];
}
@end
