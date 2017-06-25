//
//  PaymentCell.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/24/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "CustomCell.h"
@class Payment;

@interface PaymentCell : UITableViewCell
@property (nonatomic, weak) Payment *payment;

+ (CGFloat)height;

@end
