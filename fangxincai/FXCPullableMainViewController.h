//
//  FXCPullableMainViewController.h
//  fangxincai
//
//  Created by Bowen GAO on 5/22/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullTableView.h"

@interface FXCPullableMainViewController : UIViewController  <UITableViewDataSource, PullTableViewDelegate>

@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end
