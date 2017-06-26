//
//  DateFormatter.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatter : NSDateFormatter

+ (DateFormatter *)sharedInstance;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval;

@end
