//
//  UICollectionViewCell+Additions.m
//  Ethermine
//
//  Created by Dragnea Mihai on 02/03/2018.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import "UICollectionViewCell+Additions.h"

@implementation UICollectionViewCell (UICollectionViewCellAdditions)

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
