//
//  Payment.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/24/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Account;

@interface Payment : NSManagedObject
@property (nonatomic) double amount;
@property (nonatomic) BOOL confirmed;
@property (nonatomic) double date;
@property (nullable, nonatomic, copy) NSString *txHash;

@property (nullable, nonatomic, retain) Account *account;

@end
