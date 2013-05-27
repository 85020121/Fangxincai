//
//  FXCPullableMainViewController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/22/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCPullableMainViewController.h"

#import "FXCDefine.h"

#import "AFJSONRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "FXCCustomerCell.h"
#import "ECSlidingViewController.h"
#import "FXCProductViewController.h"
#import "FXCShoppingOrder.h"
#import "FXCNavigationController.h"

#define CELL_IMAGE_WIDTH            90
#define CELL_IMAGE_HEIGHT           80
#define END_OF_TABLE                @"已没有其他商品"

@interface FXCPullableMainViewController ()

@property (strong, nonatomic) UIButton *menuBtn;
//@property (strong, nonatomic) NSMutableArray *filteredProducts;
//@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (assign, nonatomic) int RequestFrom;

@end

@implementation FXCPullableMainViewController

static NSDictionary *productCategory;

@synthesize pullTableView = _pullTableView, dataSource = _dataSource;

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
    
    self.RequestFrom = 0;
    self.pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
//    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    
    
    productCategory = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"all", @"vegetable", @"fruit", @"other", nil]  forKeys:[NSArray arrayWithObjects:@"放心菜", @"新鲜蔬菜", @"时令水果", @"其他", nil]];
    
    
    // Set up menu button
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:self.menuBtn];
    self.navigationItem.leftBarButtonItem = barBtn;
    
    // Set up data source
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&category=%@&from=%d&interval=%d",FXC_PRODUCTS_BY_INTERVAL, [productCategory objectForKey:self.navigationItem.title], self.RequestFrom, REQUEST_PRODUCTS_INTERVAL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                    _dataSource = [(NSDictionary *)JSON count] > 0 ? [[NSMutableArray alloc] initWithArray:[(NSDictionary *)JSON allValues]] : [[NSMutableArray alloc] initWithObjects: nil];
                                                NSLog(@"%@",_dataSource);
    
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                            _pullTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                                                                            [_pullTableView reloadData];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                                                                            message:[NSString stringWithFormat:@"服务器连接超时,请稍后再试"]
                                                                                                                                           delegate:nil
                                                                                                                                  cancelButtonTitle:@"OK"
                                                                                                                                  otherButtonTitles:nil];
                                                                                            [alert show];
                                                                                            NSLog(@"Failed: %@",[error localizedDescription]);
                                                                                        }];
    
    [operation start];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//
//    [super viewWillAppear:animated];
//    if(!self.pullTableView.pullTableIsRefreshing) {
//        self.pullTableView.pullTableIsRefreshing = YES;
//        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
//    }
//}

- (void)viewDidUnload
{
    [self setPullTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    static NSString *CellIdent = @"FXCCustomerCell";
    
    FXCCustomerCell *cell = (FXCCustomerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdent];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FXCCustomerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure cell
    FXCProduct *product;
    product = [[FXCProduct alloc] initWith:(NSDictionary *)[_dataSource objectAtIndex:[indexPath row]]];
    
    [cell.imageFrame setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FXC_SERVER_HEAD, [product picUrl]]]];
    
    cell.nameLabel.text = [product name];
    cell.price.text = [NSString stringWithFormat:@"%@ 元",[product price]];
    cell.format.text = [product format];
    
    
    return cell;
    
}


/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 }
 */

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
    FXCProductViewController *productView = (FXCProductViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    FXCProduct *product = [[FXCProduct alloc] initWith:[_dataSource objectAtIndex:[indexPath row]]];
    productView.product = product;
    [self.navigationController pushViewController:productView animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_IMAGE_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if ((tableView != self.searchDisplayController.searchResultsTableView)
//        && (([_dataSource count]>1 && section>0) || ([_dataSource count] == 1)) ) {
//        UIView *infoBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
//        UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//        info.text = END_OF_TABLE;
//        info.textColor = [UIColor grayColor];
//        info.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
//        info.textAlignment = NSTextAlignmentCenter;
//        [infoBox addSubview:info];
//        return infoBox;
//    }
//    return nil;
//    
//}



#pragma mark - sliding method
- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}



#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}


#pragma mark - Refresh and load more methods

//- (void) refreshTable
//{
//    /*
//     
//     Code to actually refresh goes here.
//     
//     */
//    self.pullTableView.pullLastRefreshDate = [NSDate date];
//    self.pullTableView.pullTableIsRefreshing = NO;
//}

- (void) loadMoreDataToTable
{
    self.RequestFrom += 6;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&category=%@&from=%d&interval=%d",FXC_PRODUCTS_BY_INTERVAL, [productCategory objectForKey:self.navigationItem.title], self.RequestFrom, REQUEST_PRODUCTS_INTERVAL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                NSArray *result = [(NSDictionary *)JSON count] > 0 ? [(NSDictionary *)JSON allValues] : [[NSArray alloc] initWithObjects: nil];
                                                [_dataSource addObjectsFromArray:result];
                                                [_pullTableView reloadData];
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                            
                                            }];
    
    [operation start];

    self.pullTableView.pullTableIsLoadingMore = NO;
}



@end
