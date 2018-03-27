//
//  AccountInfoCell.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/23/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountInfoCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

+ (CGFloat)height;

+ (CGFloat)heightInTableView:(UITableView *)tableView title:(NSString *)title value:(NSString *)value;

@end
