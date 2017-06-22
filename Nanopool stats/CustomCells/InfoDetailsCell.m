//
//  InfoDetailsCell.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 6/22/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "InfoDetailsCell.h"

@interface InfoDetailsCell ()
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@end

@implementation InfoDetailsCell

+ (CGFloat)height {
    return 50.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tintColor = [UIColor themeColorBackground];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfoText:(NSString *)infoText {
    self.infoLabel.text = infoText;
}

@end
