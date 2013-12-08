//
//  PaymentQueueObserver.m
//  Enemy Unknown
//
//  Created by Beck Chen on 12/2/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "PaymentQueueObserver.h"
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <StoreKit/SKError.h>

@implementation PaymentQueueObserver

/**
 * When a transaction begins, send a notification.
 */
- (void)beginTransaction:(SKPaymentTransaction *)transaction
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:transactionOngoingNotification
                                                        object:self
                                                      userInfo:userInfo];
}

/**
 * When a transaction succeeds, persist the purchase and finish this transaction.
 */
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    // persist the purchase
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setBool:YES forKey:transaction.payment.productIdentifier];
    [storage synchronize];
    
    // finish transaction
    [self finishTransaction:transaction wasSuccessful:YES];
}

/**
 * When a transaction fails, finish this transaction.
 */
- (void)failTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"%@", transaction.error.description);
    [self finishTransaction:transaction wasSuccessful:NO];
}

/**
 * Finish a transaction by removing it from payment queue and send a notification about
 * whether it was successful or not.
 */
- (void)finishTransaction:(SKPaymentTransaction *)transaction
            wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from payment queue
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    // notify user of the result of purchase
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction", nil];
    if (wasSuccessful) {
        [[NSNotificationCenter defaultCenter] postNotificationName:transactionSucceededNotification
                                                            object:self
                                                          userInfo:userInfo];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:transactionFailedNotification
                                                            object:self
                                                          userInfo:userInfo];
    }
}

# pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                [self beginTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self completeTransaction:transaction.originalTransaction];
                break;
            default:
                break;
        }
    }
}

@end
