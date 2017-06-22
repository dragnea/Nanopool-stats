//
//  GraphCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/12/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "GraphCell.h"
#import "BEMSimpleLineGraphView.h"

@implementation GraphCellItem
- (id)initWithTitle:(NSString *)title value:(CGFloat)value {
    if (self = [super init]) {
        _title = title;
        _value = value;
    }
    return self;
}
@end

@interface GraphCell ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
@property (nonatomic, weak) IBOutlet BEMSimpleLineGraphView *graphView;
@property (nonatomic, weak) IBOutlet UILabel *minValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxValueLabel;
@property (nonatomic, strong) UILabel *popupLabel;
@end

@implementation GraphCell

+ (CGFloat)height {
    return 180.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *themeColor = [UIColor themeColorBackground];
    UIColor *valueColor = [UIColor blackColor];
    
    self.graphView.animationGraphStyle = BEMLineAnimationNone;
    self.graphView.animationGraphEntranceTime = 0.4f;
    self.graphView.displayDotsWhileAnimating = NO;
    self.graphView.enableBezierCurve = YES;
    self.graphView.enableReferenceXAxisLines = YES;
    self.graphView.enableReferenceAxisFrame = YES;
    self.graphView.enableYAxisLabel = YES;
    self.graphView.enablePopUpReport = YES;
    self.graphView.widthLine = 1.0f / [UIScreen mainScreen].scale;
    self.graphView.colorLine = themeColor;
    self.graphView.colorTop = [UIColor whiteColor];
    self.graphView.colorReferenceLines = valueColor;
    self.graphView.colorBottom = themeColor;
    self.graphView.colorYaxisLabel = [valueColor themeColorWithValueTitleAlpha];
    
    self.minValueLabel.textColor = self.graphView.colorYaxisLabel;
    self.maxValueLabel.textColor = self.graphView.colorYaxisLabel;
    
    self.popupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 20.0f)];
    self.popupLabel.numberOfLines = 2;
    self.popupLabel.backgroundColor = [UIColor whiteColor];
    self.popupLabel.textColor = [UIColor blackColor];
    self.popupLabel.textAlignment = NSTextAlignmentCenter;
    self.popupLabel.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightThin];
    self.popupLabel.layer.cornerRadius = 6.0f;
    self.popupLabel.layer.masksToBounds = YES;
    self.popupLabel.layer.borderWidth = 1.0f;
    self.popupLabel.layer.borderColor = themeColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItems:(NSArray<GraphCellItem *> *)items {
    _items = items;
    self.minValueLabel.text = items.firstObject.title;
    self.maxValueLabel.text = items.lastObject.title;
    [self.graphView reloadGraph];
}

#pragma mark - BEMSimpleLineGraphDataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.items.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return self.items[index].value;
}

#pragma mark - BEMSimpleLineGraphDelegate

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 8;
}

- (UIView *)popUpViewForLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.popupLabel;
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph modifyPopupView:(UILabel *)popupView forIndex:(NSUInteger)index {
    popupView.text = [NSString stringWithFormat:@"%.1f\n%@", self.items[index].value, self.items[index].title];
    CGRect popupBounds = [popupView.text boundingRectWithSize:CGSizeMake(200.0f, 100.0f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName: popupView.font}
                                                      context:nil];
    popupBounds.size.height += 8.0f;
    popupBounds.size.width += 8.0f;
    popupView.bounds = popupBounds;
}
/*
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}*/

@end
