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

@interface Account : ManagedObject
@property (nonatomic) AccountType type;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *lastUpdate;
@property (nonatomic) double balance;
@property (nonatomic) double hashrate;
@property (nullable, nonatomic, copy) NSDictionary *avgHashrate;
@property (nullable, nonatomic, retain) NSSet <Worker *>*workers;

@property (nonatomic, readonly) double avgHashrate1h;
@property (nonatomic, readonly) double avgHashrate3h;
@property (nonatomic, readonly) double avgHashrate6h;
@property (nonatomic, readonly) double avgHashrate12h;
@property (nonatomic, readonly) double avgHashrate24h;
@property (nullable, nonatomic, strong, readonly) NSString *label;

+ (NSString * _Nonnull)nameForType:(AccountType)type;
+ (NSString * _Nonnull)currencyForType:(AccountType)type;
+ (NSString * _Nullable)currencyIconForType:(AccountType)type large:(BOOL)large;
+ (NSString * _Nullable)apiForType:(AccountType)type;
+ (NSArray * _Nonnull)types;

@end
