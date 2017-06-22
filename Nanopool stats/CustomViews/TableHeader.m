//
//  TableHeader.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "TableHeader.h"

@interface TableHeader ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation TableHeader

+ (CGFloat)height {
    return 40.0f;
}

- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPathRef textBackgroundPath = CGPathCreateWithRoundedRect(CGRectInset(self.titleLabel.frame, -4.0f, -2.0f), 6.0f, 6.0f, NULL);
    CGContextAddPath(context, textBackgroundPath);
    CGPathRelease(textBackgroundPath);
    CGContextSetFillColorWithColor(context, [[UIColor themeColorBackground] themeColorWithValueTitleAlpha].CGColor);
    CGContextFillPath(context);
    
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    CGContextMoveToPoint(context, CGRectGetMaxX(self.titleLabel.frame) + 16.0f, CGRectGetMidY(self.titleLabel.frame));
    CGContextAddLineToPoint(context, rect.size.width, CGRectGetMidY(self.titleLabel.frame));
    CGContextStrokePath(context);
}

@end
