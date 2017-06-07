//
//  Worker.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/7/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "ManagedObject.h"

@class Account;

@interface Worker : ManagedObject

@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSDate *lastShare;
@property (nonatomic) double hashrate;
@property (nonatomic) double avg_h1;
@property (nonatomic) double avg_h3;
@property (nonatomic) double avg_h6;
@property (nonatomic) double avg_h12;
@property (nonatomic) double avg_h24;

@property (nullable, nonatomic, retain) Account *account;

@end
