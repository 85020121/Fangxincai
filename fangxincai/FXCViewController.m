//
//  FXCViewController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/10/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCViewController.h"

@interface FXCViewController ()

@end

@implementation FXCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // custom init
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainPage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
