//
//  Account.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "Account.h"

@implementation Account
@dynamic type;
@dynamic address;
@dynamic name;
@dynamic lastUpdate;
@dynamic hashrate;
@dynamic avgHashrate;
@dynamic balance;
@dynamic workers;

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

- (double)avgHashrate1h {
    return [self.avgHashrate[@"h1"] doubleValue];
}

- (double)avgHashrate3h {
    return [self.avgHashrate[@"h3"] doubleValue];
}

- (double)avgHashrate6h {
    return [self.avgHashrate[@"h6"] doubleValue];
}

- (double)avgHashrate12h {
    return [self.avgHashrate[@"h12"] doubleValue];
}

- (double)avgHashrate24h {
    return [self.avgHashrate[@"h24"] doubleValue];
}

- (NSString *)label {
    return (!self.name ? self.address : self.name);;
}

@end
