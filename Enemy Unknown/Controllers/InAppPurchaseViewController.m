//
//  InAppPurchaseViewController.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/19/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "InAppPurchaseViewController.h"
#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKProduct.h>

@interface InAppPurchaseViewController () <SKProductsRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *products;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SKProductsRequest *request;

@end

@implementation InAppPurchaseViewController

- (void) viewDidLoad
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"product_ids" withExtension:@"plist"];
    NSArray *productIds = [NSArray arrayWithContentsOfURL:url];
    [self validateProductIds:productIds];
}

- (void) validateProductIds:(NSArray *)productIds
{
    self.request = [[SKProductsRequest alloc]
                    initWithProductIdentifiers:[NSSet setWithArray:productIds]];
    self.request.delegate = self;
    [self.request start];
}

- (void) displayStoreUI
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    
    [self.tableView reloadData];
    self.tableView.hidden = NO;
}

- (IBAction) back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SKProductsRequest delegate

- (void) productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Received response with %d products.", [response.products count]);
    self.products = response.products;
    
    for (NSString *invalidId in response.invalidProductIdentifiers) {
        NSLog(invalidId);
    }
    
    [self displayStoreUI];
}

- (void) request:(SKRequest *)request
didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return [self.products count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Item For Purchase";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                 forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    
    // configure cell
    cell.textLabel.text = ((SKProduct *)self.products[row]).localizedTitle;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = ((SKProduct *)self.products[row]).localizedDescription;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buyButton setTitle:[NSString stringWithFormat:@"Buy at %@", ((SKProduct *)self.products[row]).price]
               forState:UIControlStateNormal];
    [buyButton setFrame:CGRectMake(0, 0, 100, 35)];
    cell.accessoryView = buyButton;
    
    return cell;
}

#pragma mark - Table view delegate

// Does not allow any cell to be selected
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

// Change background color
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor blackColor]];
}

@end
