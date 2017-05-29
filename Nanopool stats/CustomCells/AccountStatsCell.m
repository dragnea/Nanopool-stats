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
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%f", account.balance];
    
}

@end
