//
//  DMSSegmentedBar.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 8/11/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "DMSSegmentedBar.h"

@interface DMSSegmentedBar ()
@property (nonatomic, strong) NSArray <UILabel *>*labels;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic) CGRect contentFrame;

@property (nonatomic) CGFloat segmentWidth;
@end

@implementation DMSSegmentedBar

#pragma mark - Private methods

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    self.borderColor = [UIColor lightGrayColor];
    self.textColorNormal = [UIColor darkGrayColor];
    self.textColorDisabled = [UIColor lightGrayColor];
    self.textColorSelected = [UIColor blackColor];
    self.textColorHighlighted = [UIColor blackColor];
    
    self.selectedView = [[UIView alloc] initWithFrame:self.contentFrame];
    self.selectedView.layer.borderWidth = 2.0f / [UIScreen mainScreen].scale;
    self.selectedView.layer.masksToBounds = NO;
    self.selectedView.layer.shadowColor = self.borderColor.CGColor;
    self.selectedView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.selectedView.layer.shadowRadius = 3.0f;
    self.selectedView.layer.shadowOpacity = 0.6f;
    self.selectedView.userInteractionEnabled = NO;
    self.selectedView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.selectedView];
    
    self.selectedIndex = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat segmentWidth = self.segmentWidth;
    for (UILabel *segmentLabel in self.labels) {
        segmentLabel.frame = CGRectMake(segmentLabel.tag * segmentWidth, self.contentFrame.origin.y, segmentWidth, self.contentFrame.size.height);
    }
    
    self.selectedView.layer.cornerRadius = self.contentFrame.size.height / 2.0f;
    self.layer.cornerRadius = self.bounds.size.height / 2.0f;
}

- (void)setTextColorSelected:(UIColor *)textColorSelected {
    _textColorSelected = textColorSelected;
    self.selectedView.layer.borderColor = textColorSelected.CGColor;
    self.selectedView.layer.shadowColor = textColorSelected.CGColor;
    [self updateSegmentLabels];
}

- (CGRect)contentFrame {
    return CGRectInset(self.bounds, 1.0f, 1.0f);
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)segmentWidth {
    return self.contentFrame.size.width / self.labels.count;
}

- (UILabel *)segmentLabelForText:(NSString *)text {
    UILabel *segmentLabel;
    for (segmentLabel in self.labels) {
        if ([segmentLabel.text isEqualToString:text]) {
            return segmentLabel;
        }
    }
    segmentLabel = [[UILabel alloc] init];
    segmentLabel.text = text;
    segmentLabel.textAlignment = NSTextAlignmentCenter;
    segmentLabel.textColor = self.textColorNormal;
    segmentLabel.font = [UIFont systemFontOfSize:15.0f];
    segmentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:segmentLabel];
    return segmentLabel;
}

- (void)updateSegmentLabels {
    [UIView animateWithDuration:0.25f animations:^{
        for (UILabel *label in self.labels) {
            label.textColor = label.tag == _selectedIndex ? self.textColorSelected : self.textColorNormal;
        }
    }];
}

- (void)setSelectedViewPositionX:(CGFloat)positionX animanted:(BOOL)animated {
    if (positionX >= 0.0f && positionX <= self.contentFrame.size.width - self.selectedView.frame.size.width) {
        CGRect selectedViewFrame = CGRectMake(positionX, self.contentFrame.origin.y, self.segmentWidth, self.contentFrame.size.height);
        [UIView animateWithDuration:animated ? 0.25f : 0.0f animations:^{
            self.selectedView.frame = selectedViewFrame;
        }];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.4f animations:^{
        self.selectedView.backgroundColor = [self.textColorHighlighted colorWithAlphaComponent:0.1f];
    }];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    CGPoint endLocation = [touch locationInView:self];
    self.selectedIndex = truncf(endLocation.x / self.bounds.size.width * self.labels.count);
    [UIView animateWithDuration:0.4f animations:^{
        self.selectedView.backgroundColor = [UIColor clearColor];
    }];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Public methods

- (void)setSegments:(NSArray<NSString *> *)segments {
    _segments = segments;
    NSMutableArray <UILabel *>*labelsAdded = [NSMutableArray array];
    for (NSInteger index = 0; index < segments.count; index++) {
        UILabel *segmentLabel = [self segmentLabelForText:segments[index]];
        segmentLabel.tag = index;
        [labelsAdded addObject:segmentLabel];
    }
    // bring select label to front
    [self bringSubviewToFront:self.selectedView];
    
    // remove remaining labels
    for (UILabel *segmentLabel in self.labels) {
        if (![labelsAdded containsObject:segmentLabel]) {
            [segmentLabel removeFromSuperview];
        }
    }
    self.labels = labelsAdded;
    if (self.selectedIndex > labelsAdded.count - 1) {
        self.selectedIndex = labelsAdded.count - 1;
    } else {
        self.selectedIndex = self.selectedIndex;
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex < self.labels.count) {
        _selectedIndex = selectedIndex;
        CGFloat x = selectedIndex * self.segmentWidth;
        [self setSelectedViewPositionX:x animanted:YES];
        [self updateSegmentLabels];
    }
}

@end
