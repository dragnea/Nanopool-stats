//
//  DMSSegmentedBar.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 8/11/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DMSSegmentedBar : UIControl
@property (nonatomic, strong) NSArray <NSString *>*segments;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *textColorNormal;
@property (nonatomic, strong) IBInspectable UIColor *textColorHighlighted;
@property (nonatomic, strong) IBInspectable UIColor *textColorSelected;
@property (nonatomic, strong) IBInspectable UIColor *textColorDisabled;


@end
