//
//  AccountTypeHeader.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AccountTypeHeader.h"

@interface AccountTypeHeader ()
@property (nonatomic, weak) IBOutlet UIImageView *currencyImageView;
@end

@implementation AccountTypeHeader

+ (CGFloat)height {
    return 72.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.currencyImageView.backgroundColor = [UIColor whiteColor];
    self.currencyImageView.layer.cornerRadius = self.currencyImageView.bounds.size.width / 2.0f;
    self.currencyImageView.layer.masksToBounds = YES;
}

- (void)setAccountType:(AccountType)accountType {
    _accountType = accountType;
    self.currencyImageView.image = [UIImage imageNamed:[Account currencyIconForType:accountType large:NO]];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] themeColorWithSeparatorAlpha].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height - 1.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1.0f);
    CGContextStrokePath(context);
}

@end
