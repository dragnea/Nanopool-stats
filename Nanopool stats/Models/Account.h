//
//  Account.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(int16_t, AccountType) {
    AccountTypeETH
};

@interface Account : NSManagedObject
@property (nonatomic) AccountType type;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float balance;

@property (nullable, nonatomic, strong, readonly) NSString *currencyName;

@end
