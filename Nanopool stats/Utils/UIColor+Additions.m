//
//  UIColor+Additions.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor(UIColor_Additions)

+ (UIColor *)decColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)themeColorBackground {
    return [UIColor decColorWithRed:78.0f green:89.0f blue:170.0 alpha:1.0f];
}

@end
