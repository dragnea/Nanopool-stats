//
//  PaymentCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/24/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "PaymentCell.h"
#import "Payment.h"
#import "Account.h"

@interface PaymentCell ()
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation PaymentCell

+ (CGFloat)height {
    return 60.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *textsColor = [UIColor blackColor];
    self.amountLabel.textColor = [textsColor themeColorWithValueAlpha];
    self.dateLabel.textColor = [textsColor themeColorWithValueTitleAlpha];
    self.statusLabel.textColor = self.dateLabel.textColor;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterLongStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPayment:(Payment *)payment {
    _payment = payment;
    self.amountLabel.text = [NSString stringWithFormat:@"%f %@", payment.amount, [Account currencyForType:payment.account.type]];
    self.statusLabel.text = payment.confirmed ? @"Confirmed" : @"Not confirmed";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:payment.date];
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
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
