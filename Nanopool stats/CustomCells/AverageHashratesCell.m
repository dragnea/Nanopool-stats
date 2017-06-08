//
//  AverageHashratesCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/7/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AverageHashratesCell.h"
#import "Account.h"
#import "TitleValueCollectionCell.h"

@interface AverageHashratesCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <NSString *>*titles;
@property (nonatomic, strong) NSArray <NSString *>*values;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation AverageHashratesCell

+ (CGFloat)height {
    return 70.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 0.0f);
    [TitleValueCollectionCell registerNibInCollectionView:self.collectionView];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.numberFormatter.usesGroupingSeparator = NO;
    self.numberFormatter.minimumFractionDigits = 1;
    self.numberFormatter.maximumFractionDigits = 8;
    self.numberFormatter.positiveSuffix = @" MH/s";
    
    self.titles = @[@"1 hour", @"3 hours", @"6 hours", @"12 hours", @"24 hours"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccount:(Account *)account {
    _account = account;
    self.values = @[[self.numberFormatter stringFromNumber:@(account.avgHashrate1h)],
                    [self.numberFormatter stringFromNumber:@(account.avgHashrate3h)],
                    [self.numberFormatter stringFromNumber:@(account.avgHashrate6h)],
                    [self.numberFormatter stringFromNumber:@(account.avgHashrate12h)],
                    [self.numberFormatter stringFromNumber:@(account.avgHashrate24h)]];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TitleValueCollectionCell *titleValueCell = [TitleValueCollectionCell cellInCollectionView:collectionView atIndexPath:indexPath];
    [titleValueCell setValue:self.values[indexPath.item] forTitle:self.titles[indexPath.item]];
    return titleValueCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [self.values[indexPath.item] boundingRectWithSize:CGSizeMake(200.0f, collectionView.bounds.size.height)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}
                                                              context:nil].size.width + 16.0f;
    return CGSizeMake(MAX(width, collectionView.bounds.size.height), collectionView.bounds.size.height);
}

#pragma mark - UICollectionViewDelegate


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    
    // bottom line
    CGContextMoveToPoint(context, 0.0f, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

@end
