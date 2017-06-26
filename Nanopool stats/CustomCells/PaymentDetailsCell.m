//
//  PaymentDetailsCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "PaymentDetailsCell.h"
#import "Account.h"

@interface PaymentDetailsCell ()
@property (nonatomic, weak) IBOutlet UILabel *totalValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *countValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *countTitleLabel;

@end

@implementation PaymentDetailsCell

+ (CGFloat)height {
    return 60.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tintColor = [UIColor themeColorBackground];
    
    UIColor *textColor = [UIColor blackColor];
    
    self.totalValueLabel.textColor = [textColor themeColorWithValueAlpha];
    self.totalTitleLabel.textColor = [textColor themeColorWithValueTitleAlpha];
    
    self.countValueLabel.textColor = self.totalValueLabel.textColor;
    self.countTitleLabel.textColor = self.totalTitleLabel.textColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccount:(Account *)account {
    _account = account;
    
    self.totalValueLabel.text = [NSString stringWithFormat:@"%@ %@",
                                 [NumberFormatter stringFromNumber:[account valueForKeyPath:@"payments.@sum.amount"]],
                                 [Account currencyForType:account.type]];
    self.totalTitleLabel.text = @"Total paid";
    
    self.countValueLabel.text = [NSString stringWithFormat:@"%d", (int)account.payments.count];
    self.countTitleLabel.text = @"Payments";
}

@end
