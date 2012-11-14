//
//  AddDetailsViewController.h
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCell.h"
#import "MultiLineInputCell.h"
#import "CategoryViewController.h"
#import "SaveDetails.h"
#import "PlaceInfo.h"

@interface AddDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CategoryDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) PlaceInfo *placeInfo;
@property (strong, nonatomic) UITextField *placeNameTextField; 
@property (strong, nonatomic) UITextView *commentTexView;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) IBOutlet UITableView *addDetailsTableView;
@property (strong, nonatomic) SaveDetails * saveDetails; 

@end
