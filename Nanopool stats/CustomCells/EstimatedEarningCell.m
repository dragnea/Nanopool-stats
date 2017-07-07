//
//  EstimatedEarningCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "EstimatedEarningCell.h"

@interface EstimatedEarningCell ()
@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *btcLabel;
@property (nonatomic, weak) IBOutlet UILabel *usdLabel;
@end

@implementation EstimatedEarningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValues:(NSDictionary *)values {
    self.currencyLabel.text = [NSString stringWithFormat:@"%.2f", [values[@"coins"] doubleValue]];
    self.btcLabel.text = [NSString stringWithFormat:@"%.2f", [values[@"bitcoins"] doubleValue]];
    self.usdLabel.text = [NSString stringWithFormat:@"%.2f", [values[@"dollars"] doubleValue]];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPathRef textBackgroundPath = CGPathCreateWithRoundedRect(CGRectInset(self.periodLabel.frame, -4.0f, -2.0f), 6.0f, 6.0f, NULL);
    CGContextAddPath(context, textBackgroundPath);
    CGPathRelease(textBackgroundPath);
    CGContextSetFillColorWithColor(context, [[UIColor themeColorBackground] themeColorWithValueTitleAlpha].CGColor);
    CGContextFillPath(context);
    
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

@end
