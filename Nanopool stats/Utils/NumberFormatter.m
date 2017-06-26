//
//  NumberFormatter.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "NumberFormatter.h"

@implementation NumberFormatter

+ (NumberFormatter *)sharedInstance {
    static NumberFormatter *staticInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[NumberFormatter alloc] init];
        staticInstance.numberStyle = NSNumberFormatterDecimalStyle;
        staticInstance.usesGroupingSeparator = NO;
        staticInstance.minimumFractionDigits = 1;
        staticInstance.maximumFractionDigits = 8;
    });
    return staticInstance;
}

+ (NSString *)stringFromNumber:(NSNumber *)number {
    return [[NumberFormatter sharedInstance] stringFromNumber:number];
}
@end
