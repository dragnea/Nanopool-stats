//
//  CollectionReusableView+Additions.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 3/27/18.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionReusableView (CollectionReusableViewAdditions)
+ (id)supplementaryViewInCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind indexPath:(NSIndexPath *)indexPath;
+ (void)registerSupplementaryNibInCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind;
+ (void)registerSupplementaryClassInCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind;
@end
