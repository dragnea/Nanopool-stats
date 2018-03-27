//
//  AccountChartData.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 8/9/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Account;

@interface AccountChartData : NSManagedObject
@property (nonatomic) double date;
@property (nonatomic) int64_t shares;
@property (nonatomic) double hashrate;
@property (nullable, nonatomic, retain) Account *account;

@end
