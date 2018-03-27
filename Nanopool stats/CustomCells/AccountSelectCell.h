//
//  AccountSelectCell.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@interface AccountSelectCell : UITableViewCell
@property (nonatomic) AccountType accountType;
+ (CGFloat)height;
@end
