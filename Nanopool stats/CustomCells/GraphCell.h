//
//  GraphCell.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/12/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "CustomCell.h"

@interface GraphCellItem : NSObject
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, readonly) CGFloat value;
- (id)initWithTitle:(NSString *)title value:(CGFloat)value;
@end

@interface GraphCell : UITableViewCell
@property (nonatomic, weak) NSArray <GraphCellItem *>*items;
+ (CGFloat)height;
@end
