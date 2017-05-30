//
//  Account.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "ManagedObject.h"
#import <UIKit/UIColor.h>

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
@property (nonatomic) float balance;

@property (nullable, nonatomic, strong, readonly) NSString *currencyName;

+ (NSString * _Nonnull)nameForType:(AccountType)type;
+ (NSString * _Nonnull)currencyForType:(AccountType)type;
+ (UIColor * _Nonnull)colorForType:(AccountType)type;
+ (NSString * _Nullable)currencyIconForType:(AccountType)type large:(BOOL)large;
+ (NSArray * _Nonnull)types;

@end
