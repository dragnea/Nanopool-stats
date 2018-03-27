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
@dynamic isCurrent;
@dynamic hashrate;
@dynamic selectedAvgHashrateIndex;
@dynamic avgHashrate;
@dynamic balance;
@dynamic workers;
@dynamic payments;
@dynamic shares;
@dynamic chartData;

- (NSArray<ChartData *> *)sortedChartData {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    return [self.chartData sortedArrayUsingDescriptors:@[sortDescriptor]];
}

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
        case AccountTypeElectroneum:
            return @"Electroneum";
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
        case AccountTypeElectroneum:
            return @"ETN";
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
        case AccountTypeElectroneum:
            return large ? @"etn_large" : @"etn_small";
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
        case AccountTypeElectroneum:
            return @"etn";
        default:
            return nil;
    }
}

+ (NSString * _Nullable)unitForType:(AccountType)type {
    switch (type) {
        case AccountTypeEthereum:
            return @"MH/s";
        case AccountTypeEthereumClassic:
            return @"MH/s";
        case AccountTypeSiaCoin:
            return @"MH/s";
        case AccountTypeZCash:
            return @"Sol/s";
        case AccountTypeMonero:
            return @"H/s";
        case AccountTypePascal:
            return @"MH/s";
        case AccountTypeElectroneum:
            return @"H/s";
        default:
            return @"MH/s";
    }
}

+ (NSDate *)dateForAvgHour:(AccountAvgHour)avgHour {
    NSTimeInterval timeInterval;
    switch (avgHour) {
        case AccountAvgHour1h:
            timeInterval = 60.0f * 60.0f;
            break;
        case AccountAvgHour3h:
            timeInterval = 60.0f * 60.0f * 3.0f;
            break;
        case AccountAvgHour6h:
            timeInterval = 60.0f * 60.0f * 6.0f;
            break;
        case AccountAvgHour12h:
            timeInterval = 60.0f * 60.0f * 12.0f;
            break;
        case AccountAvgHour24h:
            timeInterval = 60.0f * 60.0f * 24.0f;
            break;
        default:
            timeInterval = 60.0f * 60.0f * 24.0f * 90.0f;
            break;
    }
    return [NSDate dateWithTimeInterval:-timeInterval sinceDate:[NSDate date]];
}

+ (NSArray * _Nonnull)types {
    static NSArray *types;
    if (!types) {
        types = @[@(AccountTypeEthereum),
                  @(AccountTypeEthereumClassic),
                  @(AccountTypeSiaCoin),
                  @(AccountTypeZCash),
                  @(AccountTypeMonero),
                  @(AccountTypePascal),
                  @(AccountTypeElectroneum)];
    }
    return types;
}

- (double)selectedAvgHashrate {
    return [self avgHashrateForHour:self.selectedAvgHashrateIndex];
}

+ (NSArray<NSString *> *)avgHashrateLabels {
    return @[@"1h", @"3h", @"6h", @"12h", @"24h", @"All"];
}

- (NSString *)selectedAvgHashrateTitle {
    return [self avgHashrateTitleForHour:self.selectedAvgHashrateIndex];
}

- (double)avgHashrateForHour:(AccountAvgHour)hour {
    switch (hour) {
        case AccountAvgHour1h:
            return [self.avgHashrate[@"h1"] doubleValue];
        case AccountAvgHour3h:
            return [self.avgHashrate[@"h3"] doubleValue];
        case AccountAvgHour6h:
            return [self.avgHashrate[@"h6"] doubleValue];
        case AccountAvgHour12h:
            return [self.avgHashrate[@"h12"] doubleValue];
        case AccountAvgHour24h:
            return [self.avgHashrate[@"h24"] doubleValue];
        default:
            return ([self.avgHashrate[@"h1"] doubleValue] +
                    [self.avgHashrate[@"h3"] doubleValue] +
                    [self.avgHashrate[@"h6"] doubleValue] +
                    [self.avgHashrate[@"h12"] doubleValue] +
                    [self.avgHashrate[@"h24"] doubleValue]) / 5.0f;
    }
}

- (NSString * _Nonnull)avgHashrateTitleForHour:(AccountAvgHour)hour {
    switch (hour) {
        case AccountAvgHour1h:
            return @"1 hour";
        case AccountAvgHour3h:
            return @"3 hours";
        case AccountAvgHour6h:
            return @"6 hours";
        case AccountAvgHour12h:
            return @"12 hours";
        case AccountAvgHour24h:
            return @"24 hours";
        default:
            return @"";
    }
}

- (NSString *)label {
    return (!self.name.length ? self.address : self.name);;
}

@end
