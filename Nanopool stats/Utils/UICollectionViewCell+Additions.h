//
//  UICollectionViewCell+Additions.h
//  Ethermine
//
//  Created by Dragnea Mihai on 02/03/2018.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (UICollectionViewCellAdditions)

+ (id)cellInCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
+ (void)registerNibInCollectionView:(UICollectionView *)collectionView;
+ (void)registerClassInCollectionView:(UICollectionView *)collectionView;

@end
