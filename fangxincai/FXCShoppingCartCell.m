//
//  FXCShoppingCartCell.m
//  fangxincai
//
//  Created by Bowen GAO on 5/16/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCShoppingCartCell.h"

@implementation FXCShoppingCartCell

@synthesize imageFrame = _imageFrame;
@synthesize name = _name, sum = _sum, price = _price, format = _format;
@synthesize quantity = _quantity, shipTime = _shipTime;
@synthesize priceHolder = _priceHolder;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
	[super willTransitionToState:state];
	
	if (state & UITableViewCellStateEditingMask) {
        _sum.hidden = YES;
        _format.hidden = YES;
        _quantity.borderStyle = UITextFieldViewModeAlways;
        _quantity.enabled = YES;
	}
}


- (void)didTransitionToState:(UITableViewCellStateMask)state
{
	[super didTransitionToState:state];
	
	if (!(state & UITableViewCellStateEditingMask)) {
        _quantity.borderStyle = UITextFieldViewModeNever;
        _format.hidden = NO;
        _quantity.enabled = NO;
        _sum.hidden = NO;
        _sum.text = [NSString stringWithFormat:@"%.2f元",[_quantity.text integerValue] * [_priceHolder floatValue]];
	}
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)awakeFromNib
{
    NSArray *constraints = [self.constraints copy];
    
    for (NSLayoutConstraint *constraint in constraints) {
//        NSLog(@"im %@, first %@, second is %@", constraint, constraint.firstItem, constraint.secondItem);
        
        id firstItem = constraint.firstItem;
        if (firstItem == self) {
            firstItem = self.contentView;
        }
        id secondItem = constraint.secondItem;
        if (secondItem == self) {
            secondItem = self.contentView;
        }
        
        NSLayoutConstraint *fixedConstraint = [NSLayoutConstraint constraintWithItem:firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:secondItem attribute:constraint.secondAttribute multiplier:constraint.multiplier constant:constraint.constant];
        
        [self removeConstraint:constraint];
        [self.contentView addConstraint:fixedConstraint];
    }
}


#pragma mark - Editing text fields

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if ([textField.text intValue]<=0 || [textField.text isEqualToString:@""]) {
        textField.text = @"0";
    }
    if ([textField.text intValue] > 999) {
        textField.text = @"999";
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}


- (IBAction)dismissKeyboard:(id)sender {
    [_quantity resignFirstResponder];
}

@end
