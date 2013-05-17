//
//  FXCMainTableViewController.h
//  fangxincai
//
//  Created by Bowen GAO on 5/12/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FXCProduct.h"


@interface FXCMainTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> 

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSArray *dataSource;

@end
