//
//  FXCNavigationController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/10/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCNavigationController.h"

@interface FXCNavigationController ()

@end

@implementation FXCNavigationController


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[FXCMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor whiteColor].CGColor;
    
//    UIImage *image = [UIImage imageNamed:@"bar.png"];
//    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    
//    UIImageView *bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black-navigation-bar.png"]];
//    [self.navigationBar addSubview:bar];
//    NSLog(@"width=%f and height=%f", self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
