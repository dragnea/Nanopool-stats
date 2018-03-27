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
    return [UIColor decColorWithRed:48.0f green:46.0f blue:56.0f alpha:1.0f];
}

+ (UIColor *)themeColorBackgroundDark {
    return [UIColor decColorWithRed:38.0f green:36.0f blue:46.0f alpha:1.0f];
}

+ (UIColor *)themeColorBackgroundLight {
    return [UIColor decColorWithRed:58.0f green:56.0f blue:66.0f alpha:1.0f];
}

+ (UIColor *)themeColorHighlightedHard {
    return [UIColor whiteColor];
}

+ (UIColor *)themeColorHighlightedMedium {
    return [UIColor decColorWithRed:150.0f green:151.0f blue:157.0f alpha:1.0f];
}

+ (UIColor *)themeColorHighlightedSoft {
    return [UIColor decColorWithRed:105.0f green:105.0f blue:112.0f alpha:1.0f];
}

+ (UIColor *)themeColorHighlightBlue {
    return [UIColor decColorWithRed:110.0f green:120.0f blue:220.0 alpha:1.0f];
}

+ (UIColor *)themeColorHighlightRed {
    return [UIColor decColorWithRed:195.0f green:95.0f blue:90.0f alpha:1.0f];
}

- (UIColor *)themeColorWithValueAlpha {
    return self;
}

- (UIColor *)themeColorWithValueTitleAlpha {
    return [self colorWithAlphaComponent:0.5f];
}

- (UIColor *)themeColorWithSeparatorAlpha {
    return [self colorWithAlphaComponent:0.3f];
}

@end
