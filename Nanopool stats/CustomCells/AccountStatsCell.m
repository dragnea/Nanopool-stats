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
    
    self.balanceLabel.textColor = [[UIColor whiteColor] themeColorWithValueAlpha];
    self.currentHashrateLabel.textColor = self.balanceLabel.textColor;
    self.averageHashrateLabel.textColor = self.balanceLabel.textColor;
    
    self.accountLabel.textColor = [[UIColor whiteColor] themeColorWithValueTitleAlpha];
    self.currentHashrateTitleLabel.textColor = self.accountLabel.textColor;
    self.averageHashrateTitleLabel.textColor = self.accountLabel.textColor;
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.numberFormatter.usesGroupingSeparator = NO;
    self.numberFormatter.minimumFractionDigits = 1;
    self.numberFormatter.maximumFractionDigits = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccount:(Account *)account {
    _account = account;
    
    self.accountLabel.text = account.label;
    self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@", [Account currencyForType:account.type], [self.numberFormatter stringFromNumber:@(account.balance)]];
    self.currentHashrateLabel.text = [NSString stringWithFormat:@"%@ MH/s", [self.numberFormatter stringFromNumber:@(account.hashrate)]];
    self.averageHashrateLabel.text = [NSString stringWithFormat:@"%@ MH/s", [self.numberFormatter stringFromNumber:@(account.avgHashrate6h)]];
    
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
