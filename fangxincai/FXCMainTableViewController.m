//
//  FXCMainTableViewController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/12/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCMainTableViewController.h"

#import "FXCDefine.h"

#import "AFJSONRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "FXCCustomerCell.h"
#import "FXCProductViewController.h"
#import "FXCShoppingOrder.h"
#import "FXCNavigationController.h"

#define CELL_IMAGE_WIDTH            90
#define CELL_IMAGE_HEIGHT           80
#define END_OF_TABLE                @"已没有其他商品"

@interface FXCMainTableViewController ()

@property (strong, nonatomic) NSMutableArray *filteredProducts;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation FXCMainTableViewController

static NSDictionary *productCategory;

@synthesize searchBar = _searchBar, products = _products, dataSource = _dataSource, filteredProducts = _filteredProducts;

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
    
    static int RequestFrom = 0;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    productCategory = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"all", @"vegetable", @"fruit", @"other", nil]  forKeys:[NSArray arrayWithObjects:@"放心菜", @"新鲜蔬菜", @"时令水果", @"其他", nil]];
    
    // Hide the search bar until user scrolls up
    [_searchBar sizeToFit];
    CGRect newBounds = [[self tableView] bounds];
    newBounds.origin.y = newBounds.origin.y + _searchBar.bounds.size.height;
    [[self tableView] setBounds:newBounds];

    // Set up data source
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&category=%@&from=%d&interval=%d",FXC_PRODUCTS_BY_INTERVAL, [productCategory objectForKey:self.title], RequestFrom, REQUEST_PRODUCTS_INTERVAL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            _products = [(NSDictionary *)JSON count] > 0 ? [(NSDictionary *)JSON allValues] : [[NSArray alloc] initWithObjects: nil];
            NSLog(@"Request: %@ \n %@", request, _products);
            _dataSource = [[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"test.jpg", nil], _products, nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [[self tableView] reloadData];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [_dataSource count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredProducts count];
    } else {
        return [[_dataSource objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdent = @"FXCCustomerCell";
    static NSString *CellIdent2 = @"MainTableCell";
    
    if (([indexPath section] == 0) && (tableView != self.searchDisplayController.searchResultsTableView)) {
        // Section 0 is used to show image, no-selectable
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdent2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdent2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test.jpg"]];
        return cell;
    } else {
        FXCCustomerCell *cell = (FXCCustomerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdent];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FXCCustomerCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        } else {
          //  blackImage = [UIImage imageNamed:@"black.png"];
            //cell.imageFrame.image = blackImage;
        }
        
        // Configure cell
        FXCProduct *product;
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            product = [[FXCProduct alloc] initWith:(NSDictionary *)[_filteredProducts objectAtIndex:[indexPath row]]];
        } else {
            product = [[FXCProduct alloc] initWith:(NSDictionary *)[_products objectAtIndex:[indexPath row]]];
        }
        
       // Image thread
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
//                                        [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FXC_SERVER_HEAD, [product picUrl]]]];
//        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//        [cell.imageFrame setImageWithURLRequest:request placeholderImage:blackImage
//            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                NSLog(@"Request: %@ and response: %@", request, response);
//                cell.imageFrame.image = image;
//            }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                NSLog(@"Failed: %@",[error localizedDescription]);
//        }];

        [cell.imageFrame setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FXC_SERVER_HEAD, [product picUrl]]]];

        cell.nameLabel.text = [product name];
        cell.price.text = [NSString stringWithFormat:@"%@ 元",[product price]];
        cell.format.text = [product format];
        

        return cell;    
    }

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    FXCProductViewController *productView = (FXCProductViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    FXCProduct *product = [[FXCProduct alloc] initWith:[_products objectAtIndex:[indexPath row]]];
    productView.product = product;
    [self.navigationController pushViewController:productView animated:YES];


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((tableView != self.searchDisplayController.searchResultsTableView) && [indexPath section] == 0) {
        return 200;
    } else
    return CELL_IMAGE_HEIGHT;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((tableView != self.searchDisplayController.searchResultsTableView)
        && (([_dataSource count]>1 && section>0) || ([_dataSource count] == 1)) ) {
        UIView *infoBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        info.text = END_OF_TABLE;
        info.textColor = [UIColor grayColor];
        info.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        info.textAlignment = NSTextAlignmentCenter;
        [infoBox addSubview:info];
        return infoBox;
    }
    return nil;

}


#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[_filteredProducts removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
//    NSArray *tempArray = [candyArray filteredArrayUsingPredicate:predicate];
//    
//    if(![scope isEqualToString:@"All"]) {
//        // Further filter the array with the scope
//        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
//        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
//    }
    
    _filteredProducts = [NSMutableArray arrayWithArray:[_products filteredArrayUsingPredicate:predicate]];
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
//    if ([_filteredProducts count] == 0) {
//        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
//        tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
//        for( UIView *subview in tableView1.subviews ) {
//            if( [subview class] == [UILabel class] ) {
//                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
//                lbl.text = @"没有结果";
//            }
//        }
//    }
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    // Tells the table data source to reload when scope bar selection changes
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}




@end
