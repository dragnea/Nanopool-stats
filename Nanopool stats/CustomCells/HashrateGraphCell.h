//
//  HashrateGraphCell.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/8/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "CustomCell.h"

@class Account;

@interface HashrateGraphCell : UITableViewCell
@property (nonatomic, weak) Account *account;

+ (CGFloat)height;

@end
