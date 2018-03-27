//
//  TableHeader.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) NSString *text;

+ (CGFloat)height;

@end
