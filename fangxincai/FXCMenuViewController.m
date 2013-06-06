//
//  FXCMenuViewController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/10/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCMenuViewController.h"

#import "ECSlidingViewController.h"
#import "FXCNavigationController.h"
#import "FXCMainTableViewController.h"

#define RIGHT_REVEAL_AMOUNT         200.0f

@interface FXCMenuViewController ()

@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, strong) NSDictionary *pageNibNames;
@property (nonatomic, strong) NSArray *navBarTitleNames;

@end

@implementation FXCMenuViewController

@synthesize menu = _menu, pageNibNames = _pageNibNames, navBarTitleNames = _navBarTitleNames;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.menu = [NSArray arrayWithObjects:@"首页", @"新鲜蔬菜", @"时令水果", @"其他", @"购物车", nil];
    self.pageNibNames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"FXCWelcomeViewController", @"FXCMainTableViewController", @"FXCMainTableViewController", @"FXCMainTableViewController", @"ShoppingCart", nil]  forKeys:self.menu];
    self.navBarTitleNames = [NSArray arrayWithObjects:@"放心菜", @"新鲜蔬菜", @"时令水果", @"其他", @"购物车", nil];
    
    [self.slidingViewController setAnchorRightRevealAmount:RIGHT_REVEAL_AMOUNT];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black-background.jpg"]];
    self.tableView.backgroundView = imageView;
        
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
    return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[DetailViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    NSString *identifier = [NSString stringWithFormat:@"%@",[self.pageNibNames objectForKey:[self.menu objectAtIndex:indexPath.row]]];

    if ([indexPath row] == 0) {
        [self.slidingViewController anchorTopViewOffScreenTo:ECHILD animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            [(UINavigationController *)self.slidingViewController.topViewController popToRootViewControllerAnimated:NO];
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
        return;
    }
    
    NSLog(@"return");

    FXCMainTableViewController *topView = (FXCMainTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    topView.title = [self.navBarTitleNames objectAtIndex:indexPath.row];
    
    //[newTopViewController pushViewController:topView animated:NO];
    //FXCNavigationController *newTopViewController = (FXCNavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:identifier];
    //[newTopViewController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PullView"] animated:NO];
    //newTopViewController.navigationBar.topItem.title = [self.navBarTitleNames objectAtIndex:indexPath.row];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECHILD animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
//        self.slidingViewController.topViewController = newTopViewController;
        [(UINavigationController *)self.slidingViewController.topViewController popToRootViewControllerAnimated:NO];
        [(UINavigationController *)self.slidingViewController.topViewController pushViewController:topView animated:NO];
//        [(FXCNavigationController *)self.slidingViewController.topViewController setViewControllers:@[topView]];
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}



@end
