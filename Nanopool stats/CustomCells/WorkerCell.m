//
//  WorkerCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/22/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "WorkerCell.h"
#import "Worker.h"

@interface WorkerCell ()
@property (nonatomic, weak) IBOutlet UILabel *idLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastUpdateLabel;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray <UILabel *> *valueLabels;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray <NSLayoutConstraint *> *valuesBottomConstraints;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray <UILabel *> *titleLabels;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *values;
@property (nonatomic) double maxValue;
@end

@implementation WorkerCell

+ (CGFloat)height {
    return 135.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.numberFormatter.usesGroupingSeparator = NO;
    self.numberFormatter.minimumFractionDigits = 1;
    self.numberFormatter.maximumFractionDigits = 8;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterLongStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    self.values = [NSMutableArray array];
    
    UIColor *titleColor = [UIColor blackColor];
    self.idLabel.textColor = [titleColor themeColorWithValueAlpha];
    self.lastUpdateLabel.textColor = [titleColor themeColorWithValueTitleAlpha];
    
    UIColor *graphColors = [UIColor themeColorBackground];
    for (UILabel *valueLabel in self.valueLabels) {
        valueLabel.textColor = [graphColors themeColorWithValueAlpha];
        valueLabel.backgroundColor = [[UIColor whiteColor] themeColorWithSeparatorAlpha];
    }
    
    for (UILabel *titleLabel in self.titleLabels) {
        titleLabel.textColor = [graphColors themeColorWithValueTitleAlpha];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWorker:(Worker *)worker {
    _worker = worker;
    self.idLabel.text = worker.id;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:worker.lastShare];
    self.lastUpdateLabel.text = [self.dateFormatter stringFromDate:date];
    
    [self.values addObject:@(worker.avg_h24)];
    [self.values addObject:@(worker.avg_h12)];
    [self.values addObject:@(worker.avg_h6)];
    [self.values addObject:@(worker.avg_h3)];
    [self.values addObject:@(worker.avg_h1)];
    [self.values addObject:@(worker.hashrate)];

    self.maxValue = 0.0f;
    for (NSInteger index = 0; index < self.valueLabels.count; index++) {
        double value = self.values[index].doubleValue;
        if (self.maxValue < value) {
            self.maxValue = value;
        }
        self.valueLabels[index].text = [NSString stringWithFormat:@"%.2f", value];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    
    // draw graph
    CGContextSetStrokeColorWithColor(context, self.valueLabels.firstObject.textColor.CGColor);
    CGContextSetFillColorWithColor(context, self.valueLabels.firstObject.textColor.CGColor);
    CGRect graphFrame = CGRectMake(CGRectGetMidX(self.titleLabels[0].frame),
                                   CGRectGetMaxY(self.lastUpdateLabel.frame) + 30.0f,
                                   CGRectGetMidX(self.titleLabels.lastObject.frame) - CGRectGetMidX(self.titleLabels.firstObject.frame),
                                   CGRectGetMinY(self.titleLabels.firstObject.frame) - CGRectGetMaxY(self.lastUpdateLabel.frame) - 30.0f);
    NSInteger valuesCount = self.values.count;
    CGFloat valuesXdistance = graphFrame.size.width / (valuesCount - 1);

    for (NSInteger index = 0; index < valuesCount; index++) {
        CGFloat pointX = CGRectGetMinX(graphFrame) + index * valuesXdistance;
        CGFloat bottomDistance = self.maxValue == 0.0f ? 0.0f : CGRectGetHeight(graphFrame) * self.values[index].doubleValue / self.maxValue;
        self.valuesBottomConstraints[index].constant = bottomDistance + 8.0f;
        CGFloat pointY = CGRectGetMaxY(graphFrame) - bottomDistance - 4.0f;
        if (index == 0) {
            CGContextMoveToPoint(context, pointX, pointY);
        }
        CGContextAddLineToPoint(context, pointX, pointY);
        CGContextAddEllipseInRect(context, CGRectMake(pointX - 1.0f, pointY - 1.0f, 3.0f, 3.0f));
    }
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor themeColorBackground] themeColorWithSeparatorAlpha].CGColor);

    CGContextMoveToPoint(context, CGRectGetMidX(self.titleLabels.firstObject.frame), CGRectGetMinY(self.titleLabels.firstObject.frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(self.titleLabels.lastObject.frame), CGRectGetMinY(self.titleLabels.firstObject.frame));
    CGContextStrokePath(context);
    
    // draw bottom line
    CGContextMoveToPoint(context, 0.0f, rect.size.height - 1.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1.0f);
    CGContextStrokePath(context);
}

@end
