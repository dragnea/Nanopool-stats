//
//  ShareCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "ShareCell.h"
#import "Share.h"

@interface ShareCell ()
@property (nonatomic, weak) IBOutlet UILabel *sharesNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *sharesDate;
@end

@implementation ShareCell

+ (CGFloat)height {
    return 60.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *textColor = [UIColor blackColor];
    self.sharesNumberLabel.textColor = [textColor themeColorWithValueAlpha];
    self.sharesDate.textColor = [textColor themeColorWithValueTitleAlpha];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShare:(Share *)share {
    _share = share;
    self.sharesNumberLabel.text = [NSString stringWithFormat:@"%d", (int)share.shares];
    self.sharesDate.text = [DateFormatter stringFromTimeInterval:share.date];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [[UIColor themeColorBackground] themeColorWithSeparatorAlpha].CGColor);
    
    // draw bottom line
    CGContextMoveToPoint(context, 0.0f, rect.size.height - 1.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1.0f);
    CGContextStrokePath(context);
}

@end
