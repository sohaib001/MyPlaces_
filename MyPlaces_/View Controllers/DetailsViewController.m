//
//  AddDetailsViewController.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "DetailsViewController.h"
@interface DetailsViewController()

//- (void)addPlaceNameCell:(UITableViewCell *)cell;
//- (void)addCommentCell:(UITableViewCell *)cell;
//- (void)addCategoryCell:(UITableViewCell *)cell;
- (void)addSaveButton;
- (BOOL)isCategorySelected;
-(BOOL) isPlaceNameFill;
@end

@implementation DetailsViewController

@synthesize category = _category;
@synthesize placeInfo = _placeInfo;
@synthesize placeNameTableViewCell = _placeNameTableViewCell;
@synthesize commentTableViewCell = _commentTableViewCell;


@synthesize detailsTableView = _addDetailsTableView;
@synthesize commentTexView = _commentTexView;
@synthesize placeNameTextField = _placeNameTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addSaveButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
- (void)viewDidUnload
{
   
    [self setDetailsTableView:nil];
    [self setPlaceNameTableViewCell:nil];
    [self setCommentTableViewCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [self setCategory:nil];
    [self setPlaceInfo:nil];
    [self setDetailsTableView:nil];
    [self setCommentTexView:nil];
    [self setPlaceNameTextField:nil];
    
}

-(void)addSaveButton{
    
    UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveDetailsToFile)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)saveDetailsToFile
{
   
    if (!self.isPlaceNameFill || !self.isCategorySelected) {
        UIAlertView * fillFields = [[UIAlertView alloc] initWithTitle:@"Category/Place Name" message:@"Please fill these both fields" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [fillFields show];
    }
    else{
    NSMutableDictionary *details = [[ NSMutableDictionary alloc] init];
    
    [details setObject:self.placeNameTableViewCell.placeNameTextField.text  forKey:@"Place Name"];
    [details setObject:self.commentTableViewCell.commentTextView.text forKey:@"Comments"];
   
    NSNumber * latitude = [NSNumber numberWithFloat:self.placeInfo.Coordinate.latitude];
    NSNumber * longitude = [NSNumber numberWithFloat:self.placeInfo.Coordinate.longitude];
    
    
    [details setObject:latitude forKey:@"Latitude"];
    [details setObject:longitude forKey:@"Logitude"];
  
    
  
    SaveDetails *saveDetails   = [[SaveDetails alloc] init];
    
    
    [saveDetails makePlistFileWithName:@"Details.plist"];
    [saveDetails saveDetailsInDictionary:details forKey:self.category];

    [self.navigationController popViewControllerAnimated:YES];

    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int numberOfrows = 0;
    if (section  == 0 ) {
        
        numberOfrows = 2;
    
    }else{
        
        numberOfrows = 1;
    
    }
    
    return numberOfrows;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionHeader;
    
    if (section == 1) {
        sectionHeader = @"Comment";
    }
    return sectionHeader;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    UITableViewCell *cell;
    
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                NSString *cellIdentifier=@"InputCell";
                
                cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier]; 
                if (cell==nil) {
                    
                    cell = self.placeNameTableViewCell;
                    
                    self.placeNameTextField = self.placeNameTableViewCell.placeNameTextField;
                    self.placeNameTextField.delegate = self;
                    self.placeNameTextField.text = self.placeInfo.placeName;
                
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    //[self addPlaceNameCell:cell];
                } 
            }else{
                    
                    NSString *cellIdentifier = @"Category";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (cell==nil) {
                        
                        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier]; 
                        
                        cell.textLabel.text =@"Category";
                        
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        //[self addCategoryCell:cell];
                    }     
                    cell.detailTextLabel.text = self.category;
                }
                
            }
        else{
            NSString *cellIdentifier=@"MultiLineInputCell";
            
            cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell==nil) {
                
                cell = self.commentTableViewCell;
                
                self.commentTexView   =  self.commentTableViewCell.commentTextView;
                self.commentTexView.delegate = self;
                self.commentTexView.text = self.placeInfo.comment;
                
                UIToolbar * actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
                UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStyleBordered target:self action:@selector(hideKeyboard)];
                [actionToolbar setItems:[NSArray arrayWithObject:actionButton] animated:YES];
                self.commentTexView.inputAccessoryView= actionToolbar;
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];                               
                //[self addCommentCell:cell];
            }
       
        }
            
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
    categoryViewController.delegate =self;
    categoryViewController.placeInfo = self.placeInfo;
    if (indexPath.row == 1 && indexPath.section == 0) {
        [self.navigationController pushViewController:categoryViewController animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 && indexPath.section == 1 ) {
        return 159;
    }else{
        return 44;
    }
}


#pragma mark - CategoryDelegate

-(void)didCategorySelect:(NSString *)categroy{
    

    self.category = categroy;
    self.placeInfo.category = categroy;
    [self.detailsTableView reloadData];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
        self.placeInfo.placeName = textField.text  ;
}


-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.detailsTableView.frame= CGRectMake(self.detailsTableView.frame.origin.x, self.detailsTableView.frame.origin.y, self.detailsTableView.frame.size.width, self.detailsTableView.frame.size.height - 230);
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
    [self.detailsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}


-(void) textViewDidEndEditing:(UITextView *)textView {
    
    self.detailsTableView.frame= CGRectMake(self.detailsTableView.frame.origin.x, self.detailsTableView.frame.origin.y, self.detailsTableView.frame.size.width, self.detailsTableView.frame.size.height + 230);
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
    [self.detailsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    

}

-(BOOL)isCategorySelected{
    
    BOOL result=NO;
    
    if (self.category!=nil ) {
        result = YES;
    }
    return result;
}

-(BOOL) isPlaceNameFill{
    BOOL result=NO;
    

    if (self.placeNameTableViewCell.placeNameTextField.text.length!=0) {
        result = YES;
    }
    return result;
}
- (void) hideKeyboard{
    self.placeInfo.comment = self.commentTableViewCell.commentTextView.text;
    [self.commentTexView resignFirstResponder];
}
/*
#pragma mark - UIAlertViewDelegate
-(void)alertViewCancel:(UIAlertView *)alertView{
    [self resignFirstResponder];
}

- (void) addPlaceNameCell:(UITableViewCell *)cell
{
    
        
        cell = self.placeNameTableViewCell;
        
        self.placeNameTextField = self.placeNameTableViewCell.placeNameTextField;
        
        self.placeNameTextField.delegate = self;
        self.placeNameTextField.text = self.placeInfo.placeName;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

}

- (void) addCommentCell:(UITableViewCell *)cell
{
    cell = self.commentTableViewCell;
    
    self.commentTexView   =  self.commentTableViewCell.commentTextView;
    self.commentTexView.delegate = self;
    self.commentTexView.text = self.placeInfo.comment;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void) addCategoryCell:(UITableViewCell *)cell
{
    
    cell.textLabel.text =@"Category";
    cell.detailTextLabel.text = self.category;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;      
    

}
*/
@end
