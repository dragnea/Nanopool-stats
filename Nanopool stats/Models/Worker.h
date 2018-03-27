//
//  Worker.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/7/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Account;

@interface Worker : NSManagedObject

@property (nullable, nonatomic, copy) NSString *id;
@property (nonatomic) double lastShare;
@property (nonatomic) double hashrate;
@property (nonatomic) double avg_h1;
@property (nonatomic) double avg_h3;
@property (nonatomic) double avg_h6;
@property (nonatomic) double avg_h12;
@property (nonatomic) double avg_h24;

@property (nullable, nonatomic, retain) Account *account;

@end
