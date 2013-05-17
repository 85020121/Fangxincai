//
//  FXCProductViewController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/15/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCProductViewController.h"

#import "FXCDefine.h"
#import "UIImageView+AFNetworking.h"
#import "FXCShoppingOrder.h"
#import "FXCNavigationController.h"
#import "FXCAppDelegate.h"

@interface FXCProductViewController ()

@property (strong, nonatomic) IBOutlet UIView *infoFrame;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *format;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UITextField *quantityField;
@property (strong, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (strong, nonatomic) IBOutlet UIButton *addToCart;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation FXCProductViewController

@synthesize infoFrame  = _infoFrame;
@synthesize productName = _productName, price = _price, format = _format, productImage = _productImage, duration = _duration;
@synthesize quantityField = _quantityField, quantityStepper = _quantityStepper;
@synthesize product = _product;
@synthesize managedObjectContext = _managedObjectContext;

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
    
    // Set managedObjectContext
    if (_managedObjectContext == nil) {
        _managedObjectContext = ((FXCAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    
    // Set info frame shadow
    CGRect newBounds = [_infoFrame bounds];
    newBounds.origin.y = _infoFrame.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    [_infoFrame setBounds:newBounds];
    
    // Set quantityStepper
    _quantityStepper.minimumValue = 1;
    _quantityStepper.maximumValue = 999;
    _quantityStepper.stepValue = 1;
    _quantityStepper.wraps = YES;
    _quantityStepper.autorepeat = YES;
    _quantityStepper.continuous = YES;
    _quantityField.text = [NSString stringWithFormat:@"%.f", _quantityStepper.value];
    
    // Set product info
    _productName.text = [_product name];
    _price.text = [_product price];
    _format.text = [_product format];
    [_productImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FXC_SERVER_HEAD, [_product picUrl]]] placeholderImage:[UIImage imageNamed:@"black.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)quantityChanged:(id)sender {
    _quantityField.text = [NSString stringWithFormat:@"%.f", _quantityStepper.value];
}

- (IBAction)addToCart:(id)sender {
    FXCShoppingOrder *order = (FXCShoppingOrder *)[NSEntityDescription insertNewObjectForEntityForName:@"FXCShoppingOrder" inManagedObjectContext:self.managedObjectContext];
    
    order.productID = _product.productID;
    order.date = [NSDate date];
    
    NSError *error;
    
	if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:@"未知错误，请稍后再试"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
	} else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:@"已加入购物车"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}


@end
