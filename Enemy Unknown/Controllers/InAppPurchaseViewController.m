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
    [self.tableView reloadData];
    self.tableView.hidden = NO;
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // configure cell
    cell.textLabel.text = ((SKProduct *)self.products[indexPath.row]).localizedTitle;
    cell.detailTextLabel.text = ((SKProduct *)self.products[indexPath.row]).localizedDescription;
    
    return cell;
}

#pragma mark - Table view delegate

// TODO

- (IBAction) back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
