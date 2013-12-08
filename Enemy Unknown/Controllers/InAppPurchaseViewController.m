//
//  InAppPurchaseViewController.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/19/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "InAppPurchaseViewController.h"
#import "EnemyUnknownAppDelegate.h"
#import "PaymentQueueObserver.h"
#import "Reachability.h"
#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "OLImage.h"
#import "OLImageView.h"

@interface InAppPurchaseViewController () <SKProductsRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *products;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) SKProductsRequest *request;
@property (nonatomic, strong) UIImage *purchaseImage;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation InAppPurchaseViewController

/**
 * In loadView, we load the game logo, which is a GIF animated picture, using OLImage library.
 */
- (void)loadView
{
    [super loadView];
    
    // Use OLImage and OLImageView instead of default UIImage and UIImageView in order to show gif
    self.logo = [[OLImageView alloc] initWithFrame:CGRectMake(312, 100, 400, 125)];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"gif"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    NSData *logoData = [NSData dataWithContentsOfURL:fileURL];
    UIImage *logoImage = [OLImage imageWithData:logoData];
    self.logo.image = logoImage;
    [self.view addSubview:self.logo];
}

/**
 * In viewDidLoad, we register an observer for transaction state changed notifications,
 * and an observer for reachability changed notifications. We also fetch the product infos from
 * iTunes Connect.
 */
- (void)viewDidLoad
{
    [self.activity startAnimating];
    self.activity.hidesWhenStopped = YES;
    
    // register transaction observer
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    PaymentQueueObserver *pqObserver = appDelegate.pqObserver;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(transactionStateChanged:)
                                                 name:nil
                                               object:pqObserver];
    
    // register internet availability observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    // fetch product info
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"product_ids" withExtension:@"plist"];
    NSArray *productIds = [NSArray arrayWithContentsOfURL:url];
    [self validateProductIds:productIds];
}

/**
 * Send a SKProductsRequest to fetch product infos.
 */
- (void)validateProductIds:(NSArray *)productIds
{
    self.request = [[SKProductsRequest alloc]
                    initWithProductIdentifiers:[NSSet setWithArray:productIds]];
    self.request.delegate = self;
    [self.request start];
}

/**
 * Show the items for purchase in a table view after we have product infos.
 */
- (void)displayStoreUI
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
      
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"noad" ofType:@"png"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
    self.purchaseImage = [UIImage imageWithData:fileData];
    
    [self.tableView reloadData];
    self.loadingLabel.hidden = YES;
    [self.activity stopAnimating];
    self.tableView.hidden = NO;
}

/**
 * Check if any "buy item" button is tapped.
 * If yes, make a payment for the item associated with the clicked button.
 */
- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPos = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPos];
    if (indexPath != nil) {
        [self buyProduct:[indexPath row]];
    }
}

/**
 * Make a payment for the item at specified row.
 */
- (void)buyProduct:(NSInteger)row
{
    SKProduct *product = self.products[row];
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

/**
 * Action for back button. Pop out the previous view in navigation controller.
 */
- (IBAction)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Observers

/**
 * Observer function for reachability changed notifications.
 * If the Internet becomes unavailable, show an alert and pop the previous view (main menu).
 */
- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *reachability = notification.object;
    if (![reachability isReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lost Internet Connection"
                                                        message:@"You must be connected to the Internet to purchase in-app items."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 * Observer function for transaction state changed notification.
 * Modify the text of button to notify user of the current transaction state.
 */
- (void)transactionStateChanged:(NSNotification *)notification
{
    // find the row index product related to this transaction
    SKPaymentTransaction *transaction = notification.userInfo[@"transaction"];
    NSString *productId = transaction.payment.productIdentifier;
    NSInteger index = 0;
    for (; index < [self.products count]; index++) {
        if (((SKProduct *)self.products[index]).productIdentifier == productId)
            break;
    }
    
    // find the button in that row
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    // cell is not visible, so do nothing
    if (cell == nil)
        return;
    
    // cell is visible, modify the button according to transaction state
    UIButton *button = (UIButton *)cell.accessoryView;
    if ([notification.name isEqualToString:transactionOngoingNotification]) {
        [button setTitle:@"Processing..." forState:UIControlStateNormal];
        [button removeTarget:self
                      action:@selector(checkButtonTapped:event:)
            forControlEvents:UIControlEventTouchUpInside];
        
    } else if ([notification.name isEqualToString:transactionSucceededNotification]) {
        [button setTitle:@"Bought" forState:UIControlStateNormal];
        [button removeTarget:self
                      action:@selector(checkButtonTapped:event:)
            forControlEvents:UIControlEventTouchUpInside];
        
    } else if ([notification.name isEqualToString:transactionFailedNotification]) {
        [button setTitle:[NSString stringWithFormat:@"Buy at $%@", ((SKProduct *)self.products[index]).price]
                forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(checkButtonTapped:event:)
         forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - SKProductsRequest delegate

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    
    self.products = [[NSMutableArray alloc] initWithArray:response.products];
    
    for (NSString *invalidId in response.invalidProductIdentifiers) {
        // handle invalid id
    }
    
    [self displayStoreUI];
}

- (void)request:(SKRequest *)request
didFailWithError:(NSError *)error
{
    NSLog(@"SKRequest failed: %@", error.localizedDescription);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.products count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Item For Purchase";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                 forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    
    if (row >= [self.products count]) {
        // If no product is associated with this row, show "Coming Soon"
        cell.textLabel.text = @"Coming soon . . .";
        [cell.textLabel setFont:[UIFont fontWithName:@"Copperplate" size:20]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = @"More products are on their way.";
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Copperplate" size:12]];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        NSString *filepath1 = [[NSBundle mainBundle] pathForResource:@"comingsoon" ofType:@"png"];
        NSURL *fileURL1 = [NSURL fileURLWithPath:filepath1];
        NSData *fileData1 = [NSData dataWithContentsOfURL:fileURL1];
        cell.imageView.image = [UIImage imageWithData:fileData1];
        
    } else {
        // Show information about the product
        cell.textLabel.text = ((SKProduct *)self.products[row]).localizedTitle;
        [cell.textLabel setFont:[UIFont fontWithName:@"Copperplate" size:20]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = ((SKProduct *)self.products[row]).localizedDescription;
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Copperplate" size:12]];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buyButton.titleLabel setFont:[UIFont fontWithName:@"Copperplate" size:14]];
        
        buyButton.titleLabel.textColor = [UIColor whiteColor];
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        BOOL bought = [storage boolForKey:((SKProduct *)self.products[row]).productIdentifier];
        
        if (!bought) {
            [buyButton setTitle:[NSString stringWithFormat:@"Buy at $%@",
                                 ((SKProduct *)self.products[row]).price]
                       forState:UIControlStateNormal];
            [buyButton addTarget:self
                          action:@selector(checkButtonTapped:event:)
                forControlEvents:UIControlEventTouchUpInside];
        } else {
            [buyButton setTitle:@"Bought"
                       forState:UIControlStateNormal];
        }
        
        [buyButton setFrame:CGRectMake(0, 0, 100, 35)];
        cell.accessoryView = buyButton;
        
        cell.imageView.image = self.purchaseImage;
    }
    return cell;
}

#pragma mark - Table view delegate

/**
 * Do not allow any cell to be selected.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

/**
 * Change background color to black.
 */
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor blackColor]];
}

@end
