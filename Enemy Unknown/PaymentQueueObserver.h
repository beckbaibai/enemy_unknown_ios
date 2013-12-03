//
//  PaymentQueueObserver.h
//  Enemy Unknown
//
//  Created by Beck Chen on 12/2/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/SKPaymentQueue.h>

// add a couple notifications sent out when the transaction is ongoing or completes
#define transactionOngoingNotification @"transanctionOngoingNotification"
#define transactionSucceededNotification @"transactionSucceededNotification"
#define transactionFailedNotification @"transactionFailedNotification"

@interface PaymentQueueObserver : NSObject <SKPaymentTransactionObserver>

@end
