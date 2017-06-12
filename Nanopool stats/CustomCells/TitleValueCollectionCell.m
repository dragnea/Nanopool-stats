//
//  TitleValueCollectionCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/7/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "TitleValueCollectionCell.h"

@interface TitleValueCollectionCell ()

@end

@implementation TitleValueCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *textColor = [UIColor blackColor];
    self.titleLabel.textColor = [textColor themeColorWithValueTitleAlpha];
    self.valueLabel.textColor = [textColor themeColorWithValueAlpha];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    UIColor *textColor = selected ? [UIColor whiteColor] : [UIColor blackColor];
    [UIView animateWithDuration:0.25f animations:^{
        self.titleLabel.textColor = [textColor themeColorWithValueTitleAlpha];
        self.valueLabel.textColor = [textColor themeColorWithValueAlpha];
        self.contentView.backgroundColor = selected ? [UIColor themeColorBackground] : [UIColor whiteColor];
    }];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    
    // draw left vertical line
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    CGContextAddLineToPoint(context, 0.0f, rect.size.height);
    CGContextStrokePath(context);
    
    // draw right vertical line
    CGContextMoveToPoint(context, rect.size.width, 0.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

@end
