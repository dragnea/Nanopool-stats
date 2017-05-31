//
//  DMSButton.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/31/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "DMSButton.h"

@interface DMSButton ()

@end

@implementation DMSButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 6.0f;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.5f;
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1.0f;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
