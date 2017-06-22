//
//  AccountStatsCell.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AccountStatsCell.h"
#import "Account.h"

@interface AccountStatsCell ()
@property (nonatomic, weak) IBOutlet UIImageView *currencyImageView;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *accountLabel;

@property (nonatomic, weak) IBOutlet UILabel *currentHashrateLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentHashrateTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *averageHashrateLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageHashrateTitleLabel;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@end

@implementation AccountStatsCell

+ (CGFloat)heigth {
    return 141.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tintColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [[UIColor whiteColor] themeColorWithSeparatorAlpha];
    
    self.balanceLabel.textColor = [[UIColor whiteColor] themeColorWithValueAlpha];
    self.currentHashrateLabel.textColor = self.balanceLabel.textColor;
    self.averageHashrateLabel.textColor = self.balanceLabel.textColor;
    
    self.accountLabel.textColor = [[UIColor whiteColor] themeColorWithValueTitleAlpha];
    self.currentHashrateTitleLabel.textColor = self.accountLabel.textColor;
    self.averageHashrateTitleLabel.textColor = self.accountLabel.textColor;
    
    self.currencyImageView.backgroundColor = [UIColor whiteColor];
    self.currencyImageView.layer.cornerRadius = self.currencyImageView.bounds.size.width / 2.0f;
    self.currencyImageView.layer.masksToBounds = YES;
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.numberFormatter.usesGroupingSeparator = NO;
    self.numberFormatter.minimumFractionDigits = 1;
    self.numberFormatter.maximumFractionDigits = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 4.0f, 4.0f) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4.0f, 4.0f)].CGPath;
    self.layer.mask = maskLayer;
}

- (void)setAccount:(Account *)account {
    _account = account;
    
    self.currencyImageView.image = [UIImage imageNamed:[Account currencyIconForType:account.type large:NO]];
    self.accountLabel.text = account.label;
    self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@", [self.numberFormatter stringFromNumber:@(account.balance)], [Account currencyForType:account.type]];
    self.currentHashrateLabel.text = [NSString stringWithFormat:@"%@ MH/s", [self.numberFormatter stringFromNumber:@(account.hashrate)]];
    self.averageHashrateLabel.text = [NSString stringWithFormat:@"%@ MH/s", [self.numberFormatter stringFromNumber:@([account avgHashrateForHour:AccountAvgHour6h])]];
    self.averageHashrateTitleLabel.text = [account avgHashrateTitleForHour:AccountAvgHour6h];
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] themeColorWithSeparatorAlpha].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height - 1.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1.0f);
    CGContextStrokePath(context);
}

@end
