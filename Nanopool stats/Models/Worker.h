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
@property (nonatomic) double lastshare;
@property (nonatomic) double hashrate;
@property (nonatomic) double h1;
@property (nonatomic) double h3;
@property (nonatomic) double h6;
@property (nonatomic) double h12;
@property (nonatomic) double h24;
@property (nullable, nonatomic, copy) NSString *status;

@property (nullable, nonatomic, retain) Account *account;


@end
