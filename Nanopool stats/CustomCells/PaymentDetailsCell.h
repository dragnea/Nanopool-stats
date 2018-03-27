//
//  PaymentDetailsCell.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;

@interface PaymentDetailsCell : UITableViewCell
@property (nonatomic, weak) Account *account;

+ (CGFloat)height;

@end
