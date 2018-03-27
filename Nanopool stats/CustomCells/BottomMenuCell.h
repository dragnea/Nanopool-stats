//
//  BottomMenuCell.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 3/27/18.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomMenuItem : NSObject
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *detail;
@property (nonatomic, readonly) SEL selector;
- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail selector:(SEL)selector;
@end


@interface BottomMenuCell : UICollectionViewCell
@property (nonatomic, weak) BottomMenuItem *item;
@end
