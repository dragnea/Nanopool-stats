//
//  CustomCell.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "CustomCell.h"

#define className NSStringFromClass([self class])

@implementation UITableViewHeaderFooterView (CustomHeaderFooterView)

+ (id)headerFooterInTableView:(UITableView *)tableView {
    id view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:className];
    if (!view) {
        view = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil][0];
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

@implementation UITableViewCell(CustomCell)

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


@implementation UICollectionViewCell (CustomCell)

+ (id)cellInCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
}

+ (void)registerNibInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:className];
}

+ (void)registerClassInCollectionView:(UICollectionView *)collectionView {
    return [collectionView registerClass:[self class] forCellWithReuseIdentifier:className];
}



@end

@implementation UICollectionReusableView (CustomCell)

+ (id)supplementaryViewInCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind indexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:className forIndexPath:indexPath];
}

+ (void)registerSupplementaryNibInCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind {
    [collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:className];
}

+ (void)registerSupplementaryClassInCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind {
    [collectionView registerClass:[self class] forSupplementaryViewOfKind:kind withReuseIdentifier:className];
}

@end
