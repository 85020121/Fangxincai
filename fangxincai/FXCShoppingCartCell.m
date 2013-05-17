//
//  FXCShoppingCartCell.m
//  fangxincai
//
//  Created by Bowen GAO on 5/16/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCShoppingCartCell.h"

@implementation FXCShoppingCartCell

@synthesize imageFrame = _imageFrame, name = _name, sum = _sum, priceAndFormat = _priceAndFormat;
@synthesize quantity = _quantity, shipTime = _shipTime;

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

@end
