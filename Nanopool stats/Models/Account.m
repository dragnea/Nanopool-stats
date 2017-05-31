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
@dynamic address;
@dynamic name;
@dynamic hashrate;
@dynamic avgHashrate;
@dynamic balance;

+ (NSString *)nameForType:(AccountType)type {
    switch (type) {
        case AccountTypeEthereum:
            return @"Ethereum";
        case AccountTypeEthereumClassic:
            return @"Ethereum Classic";
        case AccountTypeSiaCoin:
            return @"SiaCoin";
        case AccountTypeZCash:
            return @"ZCash";
        case AccountTypeMonero:
            return @"Monero";
        case AccountTypePascal:
            return @"Pascal";
        default:
            return @"n/a";
    }
}

+ (NSString *)currencyForType:(AccountType)type {
    switch (type) {
        case AccountTypeEthereum:
            return @"ETH";
        case AccountTypeEthereumClassic:
            return @"ETC";
        case AccountTypeSiaCoin:
            return @"SiaCoin";
        case AccountTypeZCash:
            return @"ZEC";
        case AccountTypeMonero:
            return @"XMR";
        case AccountTypePascal:
            return @"Pasc";
        default:
            return @"n/a";
    }
}

+ (UIColor * _Nonnull)colorForType:(AccountType)type {
    switch (type) {
        case AccountTypeEthereum:
            return [UIColor decColorWithRed:240.0f green:107.0f blue:71.0f alpha:1.0f];
        case AccountTypeEthereumClassic:
            return [UIColor decColorWithRed:74.0f green:185.0f blue:5.0f alpha:1.0f];
        case AccountTypeSiaCoin:
            return [UIColor decColorWithRed:55.0f green:180.0f blue:236.0f alpha:1.0f];
        case AccountTypeZCash:
            return [UIColor decColorWithRed:84.0f green:130.0f blue:171.0f alpha:1.0f];
        case AccountTypeMonero:
            return [UIColor decColorWithRed:82.0f green:82.0f blue:82.0f alpha:1.0f];
        case AccountTypePascal:
            return [UIColor decColorWithRed:255.0f green:183.0f blue:0.0f alpha:1.0f];
        default:
            return [UIColor clearColor];
    }
}

+ (NSString * _Nullable)currencyIconForType:(AccountType)type large:(BOOL)large {
    switch (type) {
        case AccountTypeEthereum:
            return large ? @"eth_large" : @"eth_small";
        case AccountTypeEthereumClassic:
            return large ? @"etc_large" : @"etc_small";
        case AccountTypeSiaCoin:
            return large ? @"siacoin_large" : @"siacoin_small";
        case AccountTypeZCash:
            return large ? @"zcash_large" : @"zcash_small";
        case AccountTypeMonero:
            return large ? @"monero_large" : @"monero_small";
        case AccountTypePascal:
            return large ? @"pascal_large" : @"pascal_small";
        default:
            return nil;
    }
}

+ (NSString * _Nullable)apiForType:(AccountType)type {
    switch (type) {
        case AccountTypeEthereum:
            return @"eth";
        case AccountTypeEthereumClassic:
            return @"etc";
        case AccountTypeSiaCoin:
            return @"sia";
        case AccountTypeZCash:
            return @"zec";
        case AccountTypeMonero:
            return @"xmr";
        case AccountTypePascal:
            return @"pasc";
        default:
            return @"";
    }
}

+ (NSArray * _Nonnull)types {
    static NSArray *types;
    if (!types) {
        types = @[@(AccountTypeEthereum),
                  @(AccountTypeEthereumClassic),
                  @(AccountTypeSiaCoin),
                  @(AccountTypeZCash),
                  @(AccountTypeMonero),
                  @(AccountTypePascal)];
    }
    return types;
}

- (double)avgHashrate6h {
    return [self.avgHashrate[@"h6"] doubleValue];
}

@end
