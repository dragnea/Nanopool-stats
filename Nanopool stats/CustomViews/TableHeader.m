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

- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height - 1.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1.0f);
    CGContextStrokePath(context);
}

@end
