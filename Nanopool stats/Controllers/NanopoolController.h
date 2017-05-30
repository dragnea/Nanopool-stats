//
//  NanopoolController.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

typedef void(^completionBlock)(NSString *error);

@interface NanopoolController : NSObject

+ (NanopoolController *)sharedInstance;

- (void)addAccountWithType:(AccountType)accountType name:(NSString *)name address:(NSString *)address completion:(completionBlock)completion;

@end
