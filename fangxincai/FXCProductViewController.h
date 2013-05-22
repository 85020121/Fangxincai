//
//  FXCProductViewController.h
//  fangxincai
//
//  Created by Bowen GAO on 5/15/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FXCProduct.h"

@interface FXCProductViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) FXCProduct *product;

@end
