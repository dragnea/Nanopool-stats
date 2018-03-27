//
//  HorizontalSelectCell.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/12/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalSelectCell;

@interface HorizontalSelectCellItem : NSObject
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *value;
- (id)initWithTitle:(NSString *)title value:(NSString *)value;
@end

@protocol HorizontalSelectCellDelegate <NSObject>
- (void)horizontalSelectCell:(HorizontalSelectCell *)horizontalSelectCell didSelectItemAtIndex:(NSInteger)index;

@end

@interface HorizontalSelectCell : UITableViewCell
@property (nonatomic, weak) id<HorizontalSelectCellDelegate>delegate;
@property (nonatomic, weak) NSArray <HorizontalSelectCellItem *> *items;
@property (nonatomic) NSInteger selectedItemIndex;
+ (CGFloat)height;
@end
