//
//  MultiLineInputCell.m
//  MyPlaces_
//
//  Created by uraan on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiLineInputCell.h"

@implementation MultiLineInputCell

@synthesize commentTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL result = YES;
    if([text isEqualToString:@"\n"])
    {
        [textView
         resignFirstResponder];
        result = NO;
    }
    return result;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.commentTextView.layer.cornerRadius = 5;
    self.commentTextView.layer.borderWidth =2 ;
    self.commentTextView.layer.borderColor = [[UIColor blackColor] CGColor];
}
@end
