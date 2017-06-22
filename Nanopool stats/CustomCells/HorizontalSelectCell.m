//
//  HorizontalSelectCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/12/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "HorizontalSelectCell.h"
#import "TitleValueCollectionCell.h"

@implementation HorizontalSelectCellItem

- (id)initWithTitle:(NSString *)title value:(NSString *)value {
    if (self = [super init]) {
        _title = [title copy];
        _value = [value copy];
    }
    return self;
}

@end

@interface HorizontalSelectCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end
@implementation HorizontalSelectCell

+ (CGFloat)height {
    return 70.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [TitleValueCollectionCell registerNibInCollectionView:self.collectionView];
    self.selectedItemIndex = 0;
    self.collectionView.contentInset = UIEdgeInsetsMake(0.0f, 16.0f, 0.0f, 16.0f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItems:(NSArray<HorizontalSelectCellItem *> *)items {
    _items = items;
    [self.collectionView reloadData];
}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex {
    _selectedItemIndex = selectedItemIndex;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TitleValueCollectionCell *titleValueCell = [TitleValueCollectionCell cellInCollectionView:collectionView atIndexPath:indexPath];
    titleValueCell.titleLabel.text = self.items[indexPath.item].title;
    titleValueCell.valueLabel.text = self.items[indexPath.item].value;
    titleValueCell.selected = self.selectedItemIndex == indexPath.item;
    return titleValueCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat titleWidth = [self.items[indexPath.item].title boundingRectWithSize:CGSizeMake(200.0f, collectionView.bounds.size.height)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}
                                                                        context:nil].size.width + 16.0f;
    
    CGFloat valueWidth = [self.items[indexPath.item].value boundingRectWithSize:CGSizeMake(200.0f, collectionView.bounds.size.height)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}
                                                                        context:nil].size.width + 16.0f;
    return CGSizeMake(MAX(MAX(titleWidth, valueWidth), collectionView.bounds.size.height), collectionView.bounds.size.height);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedItemIndex != indexPath.item) {
        self.selectedItemIndex = indexPath.item;
        if ([self.delegate respondsToSelector:@selector(horizontalSelectCell:didSelectItemAtIndex:)]) {
            [self.delegate horizontalSelectCell:self didSelectItemAtIndex:indexPath.item];
        }
    }
}
/*
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}
 */

@end
