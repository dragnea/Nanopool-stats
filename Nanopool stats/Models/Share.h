//
//  Share.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/25/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "ManagedObject.h"
@class Account;

@interface Share : ManagedObject
@property (nonatomic) double date;
@property (nonatomic) int64_t shares;
@property (nullable, nonatomic, retain) Account *account;
@end
