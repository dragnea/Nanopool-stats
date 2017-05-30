//
//  AccountTypeHeader.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AccountTypeHeader.h"

@interface AccountTypeHeader ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *currencyImageView;
@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;
@end

@implementation AccountTypeHeader

- (void)setAccountType:(AccountType)accountType {
    _accountType = accountType;
    self.nameLabel.text = [Account nameForType:accountType];
    self.currencyLabel.text = [Account currencyForType:accountType];
    self.currencyImageView.image = [UIImage imageNamed:[Account currencyIconForType:accountType large:NO]];
}

@end
