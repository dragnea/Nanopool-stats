//
//  ShareCell.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Share;

@interface ShareCell : UITableViewCell
@property (nonatomic, weak) Share *share;

+ (CGFloat)height;

@end
