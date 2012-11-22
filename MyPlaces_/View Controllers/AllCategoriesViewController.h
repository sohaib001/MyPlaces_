//
//  AllCategoriesViewController.h
//  MyPlaces_
//
//  Created by uraan on 11/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataSource;
@interface AllCategoriesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editCategoriesButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *showMapButton;
@property (strong, nonatomic) IBOutlet UITableView *AllCategoriesTableView;
@property (strong, nonatomic) DataSource *dataSource;

@end
