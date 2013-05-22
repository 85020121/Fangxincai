//
//  FXCShoppingCartCell.h
//  fangxincai
//
//  Created by Bowen GAO on 5/16/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXCShoppingCartCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageFrame;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *sum;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *shipTime;
@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) NSString *priceHolder;
@property (strong, nonatomic) IBOutlet UILabel *format;

@end
