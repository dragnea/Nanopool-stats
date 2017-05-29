//
//  Account.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "Account.h"
#import <UIKit/UIColor.h>

@implementation Account
@dynamic type;
@dynamic name;
@dynamic balance;

- (NSString *)currencyName {
    switch (self.type) {
        case AccountTypeETH:
            return @"Ethereum";
        default:
            return @"n/a";
    }
}

@end
