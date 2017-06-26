//
//  DateFormatter.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

+ (DateFormatter *)sharedInstance {
    static DateFormatter *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[DateFormatter alloc] init];
        staticInstance.dateStyle = NSDateFormatterLongStyle;
        staticInstance.timeStyle = NSDateFormatterShortStyle;
    });
    return staticInstance;
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [[DateFormatter sharedInstance] stringFromDate:date];
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    return [[DateFormatter sharedInstance] stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

@end
