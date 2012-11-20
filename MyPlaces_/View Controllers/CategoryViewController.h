//
//  CategoryViewController.h
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceInfo.h"
@protocol  CategoryDelegate <NSObject>

- (void)didCategorySelect:(NSString *) categroy;

@end

@interface CategoryViewController : UIViewController 

@property (assign) id<CategoryDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *categories;

@property (strong, nonatomic) IBOutlet UIPickerView *chooseCategoryPickerView;

@property (strong, nonatomic) NSString *selectedCategory;

@property (strong, nonatomic) PlaceInfo *placeInfo;


@end
