//
//  AccountInfoCell.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/23/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AccountInfoCell.h"

@implementation AccountInfoCell

+ (CGFloat)height {
    return 46.0f;
}

+ (CGFloat)heightInTableView:(UITableView *)tableView title:(NSString *)title value:(NSString *)value {
    CGSize textSize = CGSizeMake(tableView.bounds.size.width - 32.0f, 200.0f);
    CGFloat titleHeight = [title boundingRectWithSize:textSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}
                                              context:nil].size.height;
    CGFloat valueHeight = [value boundingRectWithSize:textSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}
                                              context:nil].size.height;
    return titleHeight + valueHeight + 10.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *textColor = [UIColor blackColor];
    self.titleLabel.textColor = [textColor themeColorWithValueTitleAlpha];
    self.valueLabel.textColor = [textColor themeColorWithValueAlpha];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
