//
//  InfoDetailsCell.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/22/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "CustomCell.h"

@interface InfoDetailsCell : UITableViewCell
@property (nonatomic, weak) NSString *infoText;
+ (CGFloat)height;
@end
