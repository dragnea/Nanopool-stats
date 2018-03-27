//
//  UITableViewCell+Additions.m
//  Ethermine
//
//  Created by Dragnea Mihai on 02/03/2018.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import "UITableViewCell+Additions.h"

@implementation UITableViewCell (UITableViewCellAdditions)

+ (id)cellInTableView:(UITableView *)tableView {
    id cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil][0];
    }
    return cell;
}

+ (id)cellInTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:className forIndexPath:indexPath];
}

+ (void)registerNibInTableView:(UITableView *)tableView {
    UINib *cellNib = [UINib nibWithNibName:className bundle:nil];
    return [tableView registerNib:cellNib forCellReuseIdentifier:className];
}

+ (void)registerClassInTableView:(UITableView *)tableView {
    return [tableView registerClass:[self class] forCellReuseIdentifier:className];
}

@end
