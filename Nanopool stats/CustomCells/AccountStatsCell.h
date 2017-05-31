//
//  AccountStatsCell.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "CustomCell.h"
#import "Account.h"

@interface AccountStatsCell : UITableViewCell

@property (nonatomic, weak) Account *account;

+ (CGFloat)heigth;

@end
