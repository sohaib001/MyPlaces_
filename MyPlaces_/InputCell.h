//
//  PlaceName.h
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *placeNameTextField;
- (IBAction)inputEntered:(id)sender;

@end
