//
//  NanopoolController.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

typedef void(^NanopoolControllerBlock)(NSString *errorString);

@interface NanopoolController : NSObject

+ (NanopoolController *)sharedInstance;

- (void)updateAccountWithAccount:(Account *)account;
- (void)updatePaymentsWithAccount:(Account *)account;
- (void)updateChartDataWithAccount:(Account *)account;

- (void)verifyAccountType:(AccountType)accountType address:(NSString *)address completion:(NanopoolControllerBlock)completion;
- (void)addAccount:(AccountType)accountType address:(NSString *)address name:(NSString *)name;



@end
