//
//  FXCMainPageViewController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/10/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCMainPageViewController.h"

#import "ECSlidingViewController.h"
#import "MMGridViewDefaultCell.h"

#import "AFJSONRequestOperation.h"


@interface FXCMainPageViewController ()

@end

@implementation FXCMainPageViewController

@synthesize menuBtn = _menuBtn, gridView = _gridView, products = _products;

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
    self.view.backgroundColor = [UIColor blackColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"black-background.jpg"]];
    NSLog(@"title is %@", [self title]);
    
    // Set up menu button
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
   // self.navigationItem.title = @"test";
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:self.menuBtn];
    self.navigationItem.leftBarButtonItem = barBtn;
    
    
    // Set up data source
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.83:8888/protected/iOS/ios_tools.php?iosRequest=iosGetProducts"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _products = (NSDictionary *)JSON;
            NSLog(@"result is: %@", _products);
            [self reload];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Failed: %@",[error localizedDescription]);
    }];
    
    [operation start];
    
    // Set up MMGrid view
    _gridView.cellMargin = 3;
    _gridView.numberOfRows = 3;
    _gridView.numberOfColumns = 2;
    // gridView.layoutStyle = HorizontalLayout;
    _gridView.layoutStyle = VerticalLayout;
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)reload
{
    [_gridView reloadData];
}


#pragma - MMGridViewDataSource

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return [_products count];
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewDefaultCell *cell = [[MMGridViewDefaultCell alloc] initWithFrame:CGRectNull];
    NSDictionary *product = [_products objectForKey:[[_products allKeys] objectAtIndex:index]];
   // cell.title.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"name"]];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.83:8888%@", [product objectForKey:@"url"]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    cell.imageFrame.image = img;
    
    cell.price.text = [NSString stringWithFormat:@"%@ 元",[product objectForKey:@"price"]];
    cell.format.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"format"]];
    return cell;
}

-(void)loadMoreForGrid
{
    //request more data here.
//    for (int i = 0; i<12; i++) {
//        [_dataSource addObject:@"Example"];
//    }
//    
    [self performSelector:@selector(LoadDataFinished) withObject:nil afterDelay:1.0];
}

-(void)LoadDataFinished
{
    [_gridView reloadData];
    [_gridView loadMoreFinished];
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
//    AnyViewController *c = [[AnyViewController alloc] initWithNibName:@"AnyViewController" bundle:nil];
//    [self.navigationController pushViewController:c animated:YES];
//    [c release];
}


- (void)gridView:(MMGridView *)gridView didDoubleTapCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"Cell at index %d was double tapped.", index]
                                                   delegate:nil
                                          cancelButtonTitle:@"Cool!"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)gridView:(MMGridView *)theGridView changedPageToIndex:(NSUInteger)index
{
}

-(BOOL)canLoadMoreForGrid
{
    //return hasMore.
    //here assume always YES.
    return NO;
}

@end

