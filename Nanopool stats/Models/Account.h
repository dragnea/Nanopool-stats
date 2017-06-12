//
//  Account.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "ManagedObject.h"

@class Worker;

typedef NS_ENUM(int16_t, AccountType) {
    AccountTypeNone,
    AccountTypeEthereum,
    AccountTypeEthereumClassic,
    AccountTypeSiaCoin,
    AccountTypeZCash,
    AccountTypeMonero,
    AccountTypePascal
};

typedef NS_ENUM(int16_t, AccountAvgHour) {
    AccountAvgHour1h = 0,
    AccountAvgHour3h = 1,
    AccountAvgHour6h = 2,
    AccountAvgHour12h = 3,
    AccountAvgHour24h = 4,
    AccountAvgHourAll = 5
};

@interface Account : ManagedObject
@property (nonatomic) AccountType type;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *lastUpdate;
@property (nonatomic) double balance;
@property (nonatomic) double hashrate;
@property (nonatomic) AccountAvgHour selectedAvgHashrateIndex;
@property (nullable, nonatomic, copy) NSDictionary *avgHashrate;
@property (nullable, nonatomic, copy) NSArray *hashrateHistory;
@property (nullable, nonatomic, retain) NSSet <Worker *>*workers;

// custom properties
@property (nonatomic, readonly) double selectedAvgHashrate;
@property (nullable, nonatomic, strong, readonly) NSString *label;

+ (NSString * _Nonnull)nameForType:(AccountType)type;
+ (NSString * _Nonnull)currencyForType:(AccountType)type;
+ (NSString * _Nullable)currencyIconForType:(AccountType)type large:(BOOL)large;
+ (NSString * _Nullable)apiForType:(AccountType)type;
+ (NSArray * _Nonnull)types;
- (double)avgHashrateForHour:(AccountAvgHour)hour;
- (NSString * _Nonnull)avgHashrateTitleForHour:(AccountAvgHour)hour;

@end
