//
//  AverageHashratesCell.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/7/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "CustomCell.h"

@class Account;

@interface AverageHashratesCell : UITableViewCell
@property (nonatomic, weak) Account *account;

+ (CGFloat)height;

@end
