//
//  Account.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Worker, Payment, Share, ChartData;

typedef NS_ENUM(int16_t, AccountType) {
    AccountTypeNone,
    AccountTypeEthereum,
    AccountTypeEthereumClassic,
    AccountTypeSiaCoin,
    AccountTypeZCash,
    AccountTypeMonero,
    AccountTypePascal,
    AccountTypeElectroneum
};

typedef NS_ENUM(int16_t, AccountAvgHour) {
    AccountAvgHour1h = 0,
    AccountAvgHour3h = 1,
    AccountAvgHour6h = 2,
    AccountAvgHour12h = 3,
    AccountAvgHour24h = 4,
    AccountAvgHourAll = 5
};

@interface Account : NSManagedObject
@property (nonatomic) AccountType type;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *lastUpdate;
@property (nonatomic) BOOL isCurrent;
@property (nonatomic) double balance;
@property (nonatomic) double hashrate;
@property (nonatomic) AccountAvgHour selectedAvgHashrateIndex;
@property (nullable, nonatomic, copy) NSDictionary *avgHashrate;
@property (nullable, nonatomic, retain) NSSet <Worker *>*workers;
@property (nullable, nonatomic, retain) NSSet <Payment *>*payments;
@property (nullable, nonatomic, retain) NSSet <Share *>*shares;
@property (nullable, nonatomic, retain) NSSet <ChartData *>*chartData;

// custom properties
@property (nullable, nonatomic, strong, readonly) NSArray <ChartData *>*sortedChartData;
@property (nonatomic, readonly) double selectedAvgHashrate;
@property (nullable, nonatomic, strong, readonly) NSString *label;

+ (NSString * _Nonnull)nameForType:(AccountType)type;
+ (NSString * _Nonnull)currencyForType:(AccountType)type;
+ (NSString * _Nullable)currencyIconForType:(AccountType)type large:(BOOL)large;
+ (NSString * _Nullable)apiForType:(AccountType)type;
+ (NSString * _Nullable)unitForType:(AccountType)type;
+ (NSArray * _Nonnull)types;
+ (NSDate * _Nonnull)dateForAvgHour:(AccountAvgHour)avgHour;
+ (NSArray <NSString *>*_Nonnull)avgHashrateLabels;
- (double)avgHashrateForHour:(AccountAvgHour)hour;
- (NSString * _Nonnull)avgHashrateTitleForHour:(AccountAvgHour)hour;

@end
