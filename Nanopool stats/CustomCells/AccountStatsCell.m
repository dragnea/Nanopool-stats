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
@property (nonatomic, weak) IBOutlet UILabel *accountTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *balanceTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *currentHashrateLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentHashrateTitleLabel;

@end

@implementation AccountStatsCell

+ (CGFloat)heigth {
    return 118.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tintColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [[UIColor whiteColor] themeColorWithSeparatorAlpha];
    
    
    self.balanceLabel.textColor = [[UIColor whiteColor] themeColorWithValueAlpha];
    self.currentHashrateLabel.textColor = self.balanceLabel.textColor;
    self.accountTitleLabel.textColor = self.balanceLabel.textColor;
    
    self.balanceTitleLabel.textColor = [[UIColor whiteColor] themeColorWithValueTitleAlpha];
    self.currentHashrateTitleLabel.textColor = self.balanceTitleLabel.textColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 4.0f, 2.0f) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4.0f, 4.0f)].CGPath;
    self.layer.mask = maskLayer;
}

- (void)setAccount:(Account *)account {
    _account = account;
    AccountType type = account.type;
    self.accountTitleLabel.text = account.label;
    self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@", [NumberFormatter stringFromNumber:@(account.balance)], [Account currencyForType:type]];
    self.currentHashrateLabel.text = [NSString stringWithFormat:@"%@ %@", [NumberFormatter stringFromNumber:@(account.hashrate)], [Account unitForType:type]];
    
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
