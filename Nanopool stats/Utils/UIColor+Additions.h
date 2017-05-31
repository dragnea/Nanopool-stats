//
//  UIColor+Additions.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(UIColor_Additions)

+ (UIColor *)decColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)themeColorBackground;

- (UIColor *)themeColorWithValueAlpha;
- (UIColor *)themeColorWithValueTitleAlpha;
- (UIColor *)themeColorWithSeparatorAlpha;

@end
