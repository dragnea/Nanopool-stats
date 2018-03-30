//
//  NanopoolController.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

static NSNotificationName NanopoolControllerDidUpdateAccountNotification = @"NanopoolControllerDidUpdateAccountNotification";
static NSNotificationName NanopoolControllerDidUpdateChartsNotification = @"NanopoolControllerDidUpdateChartsNotification";

typedef void(^NanopoolControllerBlock)(NSString *errorString);
typedef void(^NanopoolControllerEarningsBlock)(NSDictionary *response, NSString *errorString);

@interface NanopoolController : NSObject

+ (NanopoolController *)sharedInstance;

- (void)updateAccount:(Account *)account;
- (void)updatePaymentsWithAccount:(Account *)account completion:(NanopoolControllerBlock)completion;
- (void)updateChartDataWithAccount:(Account *)account;

- (void)verifyAccountType:(AccountType)accountType address:(NSString *)address completion:(NanopoolControllerBlock)completion;
- (void)addAccount:(AccountType)accountType address:(NSString *)address name:(NSString *)name;
- (void)estimatedEarningsForAccount:(Account *)account completion:(NanopoolControllerEarningsBlock)completion;


@end
