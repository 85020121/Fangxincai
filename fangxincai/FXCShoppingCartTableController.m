//
//  FXCShoppingCartTableController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/16/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCShoppingCartTableController.h"

#import "FXCNavigationController.h"
#import "FXCShoppingCartCell.h"
#import "FXCProduct.h"
#import "FXCAppDelegate.h"

#define SHOPPING_CART_CELL_HEIGHT       120

@interface FXCShoppingCartTableController ()

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation FXCShoppingCartTableController

@synthesize dataSource = _dataSource, managedObjectContext = _managedObjectContext;

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
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set managedObjectContext
    if (_managedObjectContext == nil) {
        _managedObjectContext = ((FXCAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FXCShoppingOrder"];
	[request setFetchBatchSize:20];
    
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
	NSArray *sortDescriptors = @[sortDescriptor];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch.
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        _dataSource = [[NSMutableArray alloc] init];
	} else {
    
        // Set self's events array to a mutable copy of the fetch results.
        [self setDataSource:(NSMutableArray *)[fetchResults mutableCopy]];
    }
    [self.tableView reloadData];
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
    static NSString *ShoppingCartCellIdent = @"ShoppingCartCell";
    FXCShoppingCartCell *cell = (FXCShoppingCartCell *)[tableView dequeueReusableCellWithIdentifier:ShoppingCartCellIdent forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[FXCShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShoppingCartCellIdent];
    }
    
    // Configure the cell...
    FXCProduct *product = (FXCProduct *)[_dataSource objectAtIndex:[indexPath row]];
    cell.name.text = product.productID;
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
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SHOPPING_CART_CELL_HEIGHT;

}

@end
