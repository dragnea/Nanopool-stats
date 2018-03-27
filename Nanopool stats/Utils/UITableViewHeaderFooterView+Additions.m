//
//  UITableViewHeaderFooterView+Additions.m
//  Ethermine
//
//  Created by Dragnea Mihai on 04/03/2018.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import "UITableViewHeaderFooterView+Additions.h"

@implementation UITableViewHeaderFooterView (UITableViewHeaderFooterViewAdditions)

+ (instancetype)headerInTableView:(UITableView *)tableView {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:className];
    if (!view) {
        view = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil].firstObject;
    }
    return view;
}

+ (void)registerNibInTableView:(UITableView *)tableview {
    UINib *viewNib = [UINib nibWithNibName:className bundle:nil];
    [tableview registerNib:viewNib forHeaderFooterViewReuseIdentifier:className];
}

+ (void)registerClassInTableView:(UITableView *)tableview {
    [tableview registerClass:[self class] forHeaderFooterViewReuseIdentifier:className];
}

@end
