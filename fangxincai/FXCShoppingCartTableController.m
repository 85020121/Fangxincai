//
//  FXCShoppingCartTableController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/16/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCShoppingCartTableController.h"

#import "ECSlidingViewController.h"
#import "FXCNavigationController.h"
#import "FXCShoppingCartCell.h"
#import "FXCProduct.h"
#import "FXCAppDelegate.h"
#import "AFHTTPClient.h"
#import "JSONKit.h"
#import "FXCShoppingOrder.h"
#import "UIImageView+AFNetworking.h"


#import "FXCDefine.h"

#define SHOPPING_CART_CELL_HEIGHT       120

@interface FXCShoppingCartTableController ()

@property (strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) NSDictionary *dataSource;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *coreData;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (assign, nonatomic) UITextField *tmpField;
@property (strong, nonatomic) UIToolbar *numberToolbar;
@property (strong, nonatomic) NSString *quantityBeforeChanged;
@property (assign, nonatomic) bool isEditing;
@property (strong, nonatomic) IBOutlet UIView *footInfo;

@end

@implementation FXCShoppingCartTableController

@synthesize dataSource = _dataSource, managedObjectContext = _managedObjectContext, coreData = _coreData;
@synthesize totalLabel = _totalLabel, tmpField = _tmpField;
@synthesize numberToolbar = _numberToolbar, quantityBeforeChanged = _quantityBeforeChanged;
@synthesize isEditing = _isEditing, footInfo = _footInfo;

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
    
    _isEditing = NO;
    
    // Cofigure toolbar with cancel ant done buttons for number pad
    _numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    _numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    _numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [_numberToolbar sizeToFit];
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set up menu button
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:self.menuBtn];
    self.navigationItem.leftBarButtonItem = barBtn;
    
    // Set managedObjectContext
    if (_managedObjectContext == nil) {
        _managedObjectContext = ((FXCAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FXCShoppingOrder"];
	[request setFetchBatchSize:20];
    
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = @[sortDescriptor];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch.
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	} else {    
        NSMutableArray *productsIDs = [[NSMutableArray alloc] init];
        [self setCoreData:(NSMutableArray *)[fetchResults mutableCopy]];
        [_coreData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [productsIDs addObject:[((FXCProduct *)obj) productID]];
        }];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:FXC_PRODUCTS_BY_IDS]];
        [client postPath:@"" parameters:[NSDictionary dictionaryWithObject:productsIDs forKey:@"parameters"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *resp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            _dataSource = (NSDictionary *)[resp objectFromJSONString];
            [self.tableView reloadData];
            
            __block float sum = 0.00f;
            [_coreData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                FXCShoppingOrder *order = (FXCShoppingOrder *)obj;
                sum += [order.orderQuantity floatValue] * [[[_dataSource objectForKey:order.productID] objectForKey:@"price"] floatValue];
            }];
            _totalLabel.text = [NSString stringWithFormat:@"%.2f元", sum];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed: %@",[error localizedDescription]);
        }];
        
    }
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
    return [_coreData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ShoppingCartCellIdent = @"ShoppingCartCell";
    FXCShoppingCartCell *cell = (FXCShoppingCartCell *)[tableView dequeueReusableCellWithIdentifier:ShoppingCartCellIdent forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[FXCShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShoppingCartCellIdent];
    }
    
    // Configure the cell...
    FXCShoppingOrder *order = (FXCShoppingOrder *)[_coreData objectAtIndex:[indexPath row]];
    FXCProduct *orderProduct = [[FXCProduct alloc] initWith:[_dataSource objectForKey:order.productID]];
    
    [cell.imageFrame setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FXC_SERVER_HEAD, [orderProduct picUrl]]]];
    
    cell.name.text = orderProduct.name;
    cell.priceHolder = orderProduct.price;
    cell.price.text = [NSString stringWithFormat:@"单价: %@元", orderProduct.price];
    cell.format.text = [NSString stringWithFormat:@"规格: %@", orderProduct.format];
    cell.quantity.text = [NSString stringWithFormat:@"%@", order.orderQuantity];
    
    // Calculate sum
    float sum = [orderProduct.price floatValue] * [order.orderQuantity floatValue];
    cell.sum.text = [NSString stringWithFormat:@"%.2f元", sum];
    
    cell.shipTime.text = @"60分钟以内";
    
    // Hide change quantity textfiled, show it when editing
    cell.quantity.delegate = self;
    
    // Add toolbar to number pad
    cell.quantity.inputAccessoryView = _numberToolbar;
    
    return cell;
}


#pragma mark - Table view delegate

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Ensure that if the user is editing a quantity field then the change is committed before deleting a row -- this ensures that changes are made to the correct event object.
        [tableView endEditing:YES];
		
        FXCShoppingCartCell *cell = (FXCShoppingCartCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        float sum = [cell.sum.text floatValue];
        
        // Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = (_coreData)[indexPath.row];
		[self.managedObjectContext deleteObject:eventToDelete];
		
		// Update the array and table view.
        [_coreData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
		
		// Commit the change.
		NSError *error;
		if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
		}
                
        // Update total
        float total = [_totalLabel.text floatValue] - sum;
        _totalLabel.text = [NSString stringWithFormat:@"%.2f元",total];
    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}


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

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    if(editing)
    {
        _isEditing = YES;
        _footInfo.hidden = YES;
    }
    else
    {
        if (_tmpField!=nil) {
            [self textFieldDidEndEditing:_tmpField];
        }
        _isEditing = NO;
        _footInfo.hidden = NO;
        
        // Update total
        __block float sum = 0.00f;
        [_coreData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FXCShoppingOrder *order = (FXCShoppingOrder *)obj;
            sum += [order.orderQuantity floatValue] * [[[_dataSource objectForKey:order.productID] objectForKey:@"price"] floatValue];
        }];
        _totalLabel.text = [NSString stringWithFormat:@"%.2f元", sum];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isEditing) {
        FXCShoppingCartCell *tmpCell = (FXCShoppingCartCell *)cell;
        tmpCell.sum.hidden = NO;
        tmpCell.format.hidden = NO;
        tmpCell.quantity.enabled = NO;
        tmpCell.quantity.borderStyle = UITextFieldViewModeNever;
    }
}

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


- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES; 
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SHOPPING_CART_CELL_HEIGHT;

}


#pragma mark - Editing text fields

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _tmpField = textField;
    _quantityBeforeChanged = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _tmpField = nil;
    // Quantity value have been changed, check range first
    if ([textField.text intValue] > 999) {
        textField.text = @"999";
    }
    // If quantity is 0 or nil, then remove the row
    if ([textField.text intValue] <= 0 || [textField.text isEqualToString:@""]) {
        CGPoint point = CGPointZero;
        point = [self.view convertPoint:point fromView:textField];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath ];
        _quantityBeforeChanged = @"";
        return;
    }
    
    if (![textField.text isEqualToString:_quantityBeforeChanged] && _isEditing) {
        //CGPoint point =CGPointMake(textField.center.x - textField.frame.origin.x, textField.center.y - textField.frame.origin.y);
        CGPoint point = CGPointZero;
        point = [self.view convertPoint:point fromView:textField];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath != nil) {
            FXCShoppingOrder *order = (_coreData)[indexPath.row];
            order.orderQuantity = [NSNumber numberWithInt:[textField.text integerValue]];
            
            // Commit the change.
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            } 
        }
    }
    
    _quantityBeforeChanged = @"";
}

#pragma mark - Number pad Cancel and Done events

-(void)cancelNumberPad{
    if (_tmpField != nil) {
        _tmpField.text = _quantityBeforeChanged;
        [_tmpField resignFirstResponder];
    }
}

-(void)doneWithNumberPad{
    if (_tmpField != nil) {
        [_tmpField resignFirstResponder];
    }
} 

#pragma mark - sliding method
- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
