//
//  FXCMainPageViewController.h
//  fangxincai
//
//  Created by Bowen GAO on 5/10/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMGridView.h"

@interface FXCMainPageViewController : UIViewController<MMGridViewDataSource, MMGridViewDelegate> 

@property (strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet MMGridView *gridView;

// data source
@property (strong, nonatomic) NSDictionary *products;

@end
