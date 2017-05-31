//
//  AccountSelectCell.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AccountSelectCell.h"

@interface AccountSelectCell ()
@property (nonatomic, weak) IBOutlet UIImageView *currencyImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;
@end

@implementation AccountSelectCell

+ (CGFloat)height {
    return 60.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.textColor = [[UIColor blackColor] themeColorWithValueAlpha];
    self.currencyLabel.textColor = [[UIColor blackColor] themeColorWithValueTitleAlpha];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.contentView.backgroundColor = [[UIColor themeColorBackground] colorWithAlphaComponent:1.0f];
        self.nameLabel.textColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.nameLabel.textColor = [UIColor blackColor];
    }
}

- (void)setAccountType:(AccountType)accountType {
    _accountType = accountType;
    self.nameLabel.text = [Account nameForType:accountType];
    self.currencyLabel.text = [Account currencyForType:accountType];
    self.currencyImageView.image = [UIImage imageNamed:[Account currencyIconForType:accountType large:NO]];
}

@end
