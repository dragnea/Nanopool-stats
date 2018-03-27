//
//  AccountTypeHeader.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AccountTypeHeader.h"
#import "DBController.h"

@interface AccountTypeHeader ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@end

@implementation AccountTypeHeader

+ (CGFloat)height {
    return 60.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor themeColorBackground];
    
    self.iconImageView.backgroundColor = [UIColor whiteColor];
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2.0f;
    self.iconImageView.layer.masksToBounds = YES;
    
    UIColor *textColor = [UIColor whiteColor];
    self.nameLabel.textColor = [textColor themeColorWithValueAlpha];
    self.descriptionLabel.textColor = [textColor themeColorWithValueTitleAlpha];
}

- (void)setAccountType:(AccountType)accountType {
    _accountType = accountType;
    self.iconImageView.image = [UIImage imageNamed:[Account currencyIconForType:accountType large:NO]];
    self.nameLabel.text = [Account nameForType:accountType];
    NSArray *accounts = [Account entitiesInContext:[DBController mainContext] predicate:[NSPredicate predicateWithFormat:@"type == %d", (int)accountType]];
    NSNumber *total = [accounts valueForKeyPath:@"@sum.balance"];
    self.descriptionLabel.text = [NSString stringWithFormat:@"Total: %@ %@", total, [Account currencyForType:accountType]];
}

/*
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] themeColorWithSeparatorAlpha].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height - 1.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1.0f);
    CGContextStrokePath(context);
}*/

@end
