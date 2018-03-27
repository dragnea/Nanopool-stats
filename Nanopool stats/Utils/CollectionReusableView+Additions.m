//
//  CollectionReusableView+Additions.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 3/27/18.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import "CollectionReusableView+Additions.h"

@implementation UICollectionReusableView (CollectionReusableViewAdditions)

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
