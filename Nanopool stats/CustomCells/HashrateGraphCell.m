//
//  HashrateGraphCell.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/8/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "HashrateGraphCell.h"
#import "Account.h"

@interface HashrateGraphCell ()
@property (nonatomic) double maxValue;
@property (nonatomic) NSInteger yAxisLinesCount;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *yAxisLabels;
@end

@implementation HashrateGraphCell

+ (CGFloat)height {
    return 150.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.yAxisLinesCount = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccount:(Account *)account {
    _account = account;
    self.maxValue = [[account.hashrateHistory valueForKeyPath:@"@max.hashrate"] doubleValue];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect contentFrame = self.scrollView.frame;
    CGFloat yAxisLinesSpace = contentFrame.size.height / self.yAxisLinesCount;
    double hashrateScale = contentFrame.size.height / self.maxValue;
    
    CGContextSetLineWidth(context, 1.0f / [UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.0f alpha:0.1f].CGColor);
    
    NSDictionary *labelsAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName: [UIColor colorWithWhite:0.5f alpha:1.0f]};
    for (NSInteger yAxisLineIndex = 0; yAxisLineIndex < self.yAxisLinesCount; yAxisLineIndex++) {
        
        // draw horizontal lines
        CGFloat yAxisLineCoord = contentFrame.size.height - yAxisLineIndex * yAxisLinesSpace;
        CGContextMoveToPoint(context, CGRectGetMinX(contentFrame), yAxisLineCoord);
        CGContextAddLineToPoint(context, CGRectGetMaxX(contentFrame), yAxisLineCoord);
        CGContextStrokePath(context);
        
        // draw horizontal labels
        CGRect labelFrame = CGRectMake(16.0f, yAxisLineCoord - 10.0f, CGRectGetMinX(contentFrame) - 16.0f, 15.0f);
        [@"label" drawInRect:labelFrame withAttributes:labelsAttributes];
    }
    
    NSInteger numberOfHashrates = self.account.hashrateHistory.count;
    for (NSInteger hashrateIndex = 0; hashrateIndex < numberOfHashrates; hashrateIndex++) {
        NSDictionary *hashrateDictionary = self.account.hashrateHistory[hashrateIndex];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[hashrateDictionary[@"date"] doubleValue]];
        double hashrate = [hashrateDictionary[@"hashrate"] doubleValue];
        
    }
    
    // bottom line
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

@end
