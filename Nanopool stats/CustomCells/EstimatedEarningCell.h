//
//  EstimatedEarningCell.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstimatedEarningCell : UITableViewCell
@property (nonatomic, weak) NSDictionary *values;
+ (CGFloat)height;
@end
