//
//  TitleValueCollectionCell.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/7/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleValueCollectionCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@end
