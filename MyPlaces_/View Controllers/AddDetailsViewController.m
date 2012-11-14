//
//  AddDetailsViewController.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddDetailsViewController.h"

@implementation AddDetailsViewController

@synthesize category = _category;
@synthesize placeInfo = _placeInfo;
@synthesize saveDetails = _saveDetails;
@synthesize addDetailsTableView = _addDetailsTableView;
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
    UIBarButtonItem	*saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveDetailsToFile)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewDidUnload
{
   
    [self setAddDetailsTableView:nil];
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
    [self setSaveDetails:nil];
    [self setAddDetailsTableView:nil];
    [self setCommentTexView:nil];
    [self setPlaceNameTextField:nil];
    
}

- (void)saveDetailsToFile
{
   
    NSMutableDictionary *details = [[ NSMutableDictionary alloc] init];
    
    [details setObject:self.placeNameTextField.text  forKey:@"Place Name"];
    [details setObject:self.commentTexView.text forKey:@"Comments"];
   
    NSNumber * latitude = [NSNumber numberWithFloat:self.placeInfo.Coordinate.latitude];
    NSNumber * longitude = [NSNumber numberWithFloat:self.placeInfo.Coordinate.longitude];
    
    
    [details setObject:latitude forKey:@"Latitude"];
    [details setObject:longitude forKey:@"Logitude"];
    //[details setObject:self.category forKey:@"Category"];
    
    if (self.saveDetails== nil) {
        self.saveDetails = [[SaveDetails alloc] init];
    }
    
    [self.saveDetails makePlistFileWithName:@"Details.plist"];
    [self.saveDetails saveDetailsInDictionary:details forKey:self.category];

   
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
         NSString *cellIdentifier=@"InputCell";
        cell=(InputCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            self.placeNameTextField =  [(InputCell *) cell placeNameTextField];
            
            self.placeNameTextField.delegate = self;
            
            self.placeNameTextField.text = self.placeInfo.placeName;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        


    }else if(indexPath.row == 2) {
        
        NSString *cellIdentifier=@"MultiLineInputCell";
        
       cell=(MultiLineInputCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MultiLineInputCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
            self.commentTexView   =  [(MultiLineInputCell *) cell commentTextView];
            
            self.commentTexView.delegate = self;
            
            self.commentTexView.text = self.placeInfo.comment;
             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }else{
        
        NSString *cellIdentifier = @"Category";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text =@"Category";
        cell.detailTextLabel.text = self.category;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;      
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
    categoryViewController.delegate =self;
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:categoryViewController animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    if (indexPath.row == 2) {
        return 140;
    }else{
        return 44;
    }
}


#pragma mark - CategoryDelegate
-(void)didCategorySelect:(NSString *)categroy{
    
    self.category = categroy;
    [self.addDetailsTableView reloadData];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{

    self.placeInfo.placeName = textField.text  ;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL result = YES;
    if([text isEqualToString:@"\n"])
    {
        self.placeInfo.comment = textView.text;
        [textView
         resignFirstResponder];
        result = NO;
    }
    return result;
}


@end
