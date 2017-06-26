//
//  NumberFormatter.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberFormatter : NSNumberFormatter

+ (NumberFormatter *)sharedInstance;
+ (NSString *)stringFromNumber:(NSNumber *)number;

@end
