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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccount:(Account *)account {
    _account = account;
    [self.graphView reloadGraph];
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

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

@end
