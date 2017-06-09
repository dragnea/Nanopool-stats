//
//  HashrateGraphCell.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/8/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "HashrateGraphCell.h"
#import "Account.h"
#import "BEMSimpleLineGraphView.h"

@interface HashrateGraphCell ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
@property (nonatomic, weak) IBOutlet BEMSimpleLineGraphView *graphView;
@property (nonatomic, weak) IBOutlet UILabel *firstDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastDateLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation HashrateGraphCell

+ (CGFloat)height {
    return 180.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *themeColor = [UIColor themeColorBackground];
    
    self.graphView.animationGraphStyle = BEMLineAnimationFade;
    self.graphView.animationGraphEntranceTime = 1.0f;
    self.graphView.displayDotsWhileAnimating = NO;
    self.graphView.enableBezierCurve = YES;
    self.graphView.enableReferenceAxisFrame = YES;
    self.graphView.enableYAxisLabel = YES;
    self.graphView.enablePopUpReport = YES;
    self.graphView.widthLine = 1.0f / [UIScreen mainScreen].scale;
    self.graphView.colorLine = themeColor;
    self.graphView.colorTop = [UIColor whiteColor];
    self.graphView.colorReferenceLines = [UIColor blackColor];
    self.graphView.colorBottom = themeColor;
    self.graphView.colorYaxisLabel = [[UIColor blackColor] themeColorWithValueTitleAlpha];
    
    self.firstDateLabel.textColor = [[UIColor blackColor] themeColorWithValueTitleAlpha];
    self.lastDateLabel.textColor = self.firstDateLabel.textColor;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"YYYYMMMdd jm" options:0 locale:[NSLocale currentLocale]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccount:(Account *)account {
    _account = account;
    self.firstDateLabel.text = [self stringDateAtIndex:0];
    self.lastDateLabel.text = [self stringDateAtIndex:account.hashrateHistory.count - 1];
    [self.graphView reloadGraph];
}

- (NSString *)stringDateAtIndex:(NSInteger)index {
    return [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.account.hashrateHistory[index][@"date"] doubleValue]]];
}

#pragma mark - BEMSimpleLineGraphDataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.account.hashrateHistory.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [self.account.hashrateHistory[index][@"hashrate"] floatValue];
}

#pragma mark - BEMSimpleLineGraphDelegate

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 8;
}

- (UIView *)popUpViewForLineGraph:(BEMSimpleLineGraphView *)graph {
    UILabel *popupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 20.0f)];
    popupLabel.backgroundColor = [UIColor whiteColor];
    popupLabel.textColor = [UIColor blackColor];
    popupLabel.textAlignment = NSTextAlignmentCenter;
    popupLabel.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightThin];
    return popupLabel;
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph modifyPopupView:(UILabel *)popupView forIndex:(NSUInteger)index {
    popupView.text = [NSString stringWithFormat:@"%.1f %@", [self.account.hashrateHistory[index][@"hashrate"] doubleValue], [self stringDateAtIndex:index]];
    [popupView sizeToFit];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

@end
