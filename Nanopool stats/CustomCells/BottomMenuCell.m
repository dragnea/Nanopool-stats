//
//  BottomMenuCell.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 3/27/18.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import "BottomMenuCell.h"

@implementation BottomMenuItem
- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail selector:(SEL)selector {
    if (self = [super init]) {
        _title = title;
        _detail = detail;
        _selector = selector;
    }
    return self;
}
@end

@interface BottomMenuCell ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@end

@implementation BottomMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGFloat margin = 4.0f;
    CGRect maskRect = CGRectMake(margin,margin, self.bounds.size.width - 2.0f * margin, self.bounds.size.height - 2.0f * margin);
    CGPathRef path = CGPathCreateWithRoundedRect(maskRect, margin, margin, NULL);
    maskLayer.path = path;
    CGPathRelease(path);
    self.layer.mask = maskLayer;
}

- (void)setItem:(BottomMenuItem *)item {
    _item = item;
    self.titleLabel.text = item.title;
    self.detailLabel.text = item.detail;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [UIView animateWithDuration:(highlighted ? 0.0f: 0.25f) animations:^{
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:(highlighted ? 0.5f : 0.1f)];
    }];
}

@end
