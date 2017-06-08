//
//  TitleValueCollectionCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/7/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "TitleValueCollectionCell.h"

@interface TitleValueCollectionCell ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
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
    /* make visible a cell selection. used to set average hours for hashrate in dashboard
    UIColor *textColor = selected ? [UIColor whiteColor] : [UIColor blackColor];
    [UIView animateWithDuration:0.25f animations:^{
        self.titleLabel.textColor = [textColor themeColorWithValueTitleAlpha];
        self.valueLabel.textColor = [textColor themeColorWithValueAlpha];
        self.contentView.backgroundColor = selected ? [UIColor themeColorBackground] : [UIColor whiteColor];
    }];
    */
}

- (void)setValue:(NSString *)value forTitle:(NSString *)title {
    self.titleLabel.text = title;
    self.valueLabel.text = value;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [[UIColor themeColorBackground] themeColorWithSeparatorAlpha].CGColor);
    
    // vertical line
    CGContextMoveToPoint(context, rect.size.width, 4.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 4.0f);
    CGContextStrokePath(context);
}

@end
