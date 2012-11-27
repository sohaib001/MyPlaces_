//
//  CategoryViewController.h
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceInfo.h"
@class DataSource;

@protocol  CategoryDelegate <NSObject>

- (void)didCategorySelect:(NSString *) categroy;

@end

@interface CategoryViewController : UIViewController 

@property (strong, nonatomic) NSString *selectedCategory;
@property (strong, nonatomic) PlaceInfo *placeInfo;
@property (assign) id<CategoryDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *chooseCategoryPickerView;



@end
