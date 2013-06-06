//
//  FXCWelcomeViewController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/27/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCWelcomeViewController.h"
#import "FXCMainTableViewController.h"
#import "ECSlidingViewController.h"

#define MAIN_VIEW_CONTROLLER        @"FXCMainTableViewController"
#define WELCOME_CELL_HEIGHT         70.0f

@interface FXCWelcomeViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) UIButton *menuBtn;
@end

@implementation FXCWelcomeViewController

@synthesize tableView = _tableView, dataSource = _dataSource;
@synthesize menuBtn = _menuBtn;

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
    
    _dataSource = [[NSArray alloc] initWithObjects:@"新鲜蔬菜", @"时令水果", @"其他", nil];
    
    // Set up menu button
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:self.menuBtn];
    self.navigationItem.leftBarButtonItem = barBtn;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *WelcomeCellIdentifier = @"WelcomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WelcomeCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WelcomeCellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [_dataSource objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_dataSource objectAtIndex:indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:@"test.jpg"];//[[UIImageView alloc] ]
    cell.imageView.contentMode  = UIViewContentModeScaleToFill;
    // Configure the cell...
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXCMainTableViewController *mainView = (FXCMainTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:MAIN_VIEW_CONTROLLER];
    mainView.title = [_dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:mainView animated:YES];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WELCOME_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}



#pragma mark - sliding method
- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
