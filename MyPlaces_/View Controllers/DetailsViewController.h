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
#import "PlaceInfo.h"

@interface DetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CategoryDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) PlaceInfo *placeInfo;
@property (strong, nonatomic) UITextField *placeNameTextField; 
@property (strong, nonatomic) UITextView *commentTexView;
@property (strong, nonatomic) NSString *category;


@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;

@property (strong, nonatomic) IBOutlet InputCell *placeNameTableViewCell;

@property (strong, nonatomic) IBOutlet MultiLineInputCell *commentTableViewCell;

@end
