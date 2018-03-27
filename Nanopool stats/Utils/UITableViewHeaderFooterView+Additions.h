//
//  UITableViewHeaderFooterView+Additions.h
//  Ethermine
//
//  Created by Dragnea Mihai on 04/03/2018.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewHeaderFooterView (UITableViewHeaderFooterViewAdditions)

+ (instancetype)headerInTableView:(UITableView *)tableView;
+ (void)registerNibInTableView:(UITableView *)tableview;
+ (void)registerClassInTableView:(UITableView *)tableview;

@end
