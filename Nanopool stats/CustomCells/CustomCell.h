//
//  CustomCell.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewHeaderFooterView (CustomHeaderFooterView)

+ (id)headerFooterInTableView:(UITableView *)tableView;
+ (void)registerNibInTableView:(UITableView *)tableview;
+ (void)registerClassInTableView:(UITableView *)tableview;

@end

@interface UITableViewCell(CustomCell)

+ (id)cellInTableView:(UITableView *)tableView;
+ (id)cellInTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
+ (void)registerNibInTableView:(UITableView *)tableView;
+ (void)registerClassInTableView:(UITableView *)tableView;
+ (UITableViewCell *)dummyTableViewCell;

@end

@interface UICollectionViewCell (CustomCell)

+ (id)cellInCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
+ (void)registerNibInCollectionView:(UICollectionView *)collectionView;
+ (void)registerClassInCollectionView:(UICollectionView *)collectionView;

@end

@interface UICollectionReusableView (CustomCell)

+ (id)supplementaryViewInCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind indexPath:(NSIndexPath *)indexPath;
+ (void)registerSupplementaryNibInCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind;
+ (void)registerSupplementaryClassInCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind;

@end
