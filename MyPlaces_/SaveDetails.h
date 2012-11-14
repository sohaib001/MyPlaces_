//
//  SaveDetails.h
//  MyPlaces_
//
//  Created by uraan on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveDetails : NSObject

@property (strong, nonatomic) NSString *plistLocation;
@property (strong, nonatomic) NSFileManager *fileManager;

-(void) makePlistFileWithName:(NSString *)pListName;
-(void)saveDetailsInDictionary:(NSDictionary *) details forKey:(NSString *) key;
@end
