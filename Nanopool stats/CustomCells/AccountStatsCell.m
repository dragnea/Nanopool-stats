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
@property (nonatomic, weak) IBOutlet UILabel *accountLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentHashrateLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageHashrateLabel;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@end

@implementation AccountStatsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccount:(Account *)account {
    _account = account;
    
    self.accountLabel.text = (!account.name ? account.address : account.name);
    self.balanceLabel.text = [NSString stringWithFormat:@"%f %@", account.balance, [Account currencyForType:account.type]];
    
}

@end
