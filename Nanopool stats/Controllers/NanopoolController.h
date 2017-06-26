//
//  NanopoolController.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

typedef void(^completionBlock)(UIBackgroundFetchResult result);
typedef void(^completionResultBlock)(NSDictionary *result);

@interface NanopoolController : NSObject

+ (NanopoolController *)sharedInstance;

- (void)updateAccounts:(completionBlock)completion;
- (void)addAccountWithType:(AccountType)accountType name:(NSString *)name address:(NSString *)address completion:(completionBlock)completion;
- (void)estimatedEarningsForAddress:(NSString *)address completion:(completionResultBlock)completion;

@end
