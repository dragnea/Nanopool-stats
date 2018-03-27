//
//  UITableViewCell+Additions.h
//  Ethermine
//
//  Created by Dragnea Mihai on 02/03/2018.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (UITableViewCellAdditions)

+ (id)cellInTableView:(UITableView *)tableView;
+ (id)cellInTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
+ (void)registerNibInTableView:(UITableView *)tableView;
+ (void)registerClassInTableView:(UITableView *)tableView;

@end
