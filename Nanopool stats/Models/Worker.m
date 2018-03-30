//
//  Worker.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/7/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "Worker.h"

@implementation Worker

@dynamic id;
@dynamic lastshare;
@dynamic hashrate;
@dynamic h1;
@dynamic h3;
@dynamic h6;
@dynamic h12;
@dynamic h24;
@dynamic status;

@dynamic account;

- (void)awakeFromFetch {
    [super awakeFromFetch];
    self.status = self.hashrate > 0 ? @"Active" : @"Inactive";
}

@end
