//
//  WorkerCell.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/22/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "CustomCell.h"

@class Worker;

@interface WorkerCell : UITableViewCell
@property (nonatomic, weak) Worker *worker;

+ (CGFloat)height;

@end
