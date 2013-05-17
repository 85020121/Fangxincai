//
//  FXCCustomerCell.m
//  fangxincai
//
//  Created by Bowen GAO on 5/12/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCCustomerCell.h"

@implementation FXCCustomerCell

@synthesize imageFrame = _imageFrame, nameLabel = _nameLabel, price = _price, format = _format;

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
