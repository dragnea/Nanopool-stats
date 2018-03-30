//
//  EstimatedEarningCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "EstimatedEarningCell.h"

@interface EstimatedEarningCell ()
@property (nonatomic, weak) IBOutlet UILabel *periodLabel;
@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *btcLabel;
@property (nonatomic, weak) IBOutlet UILabel *usdLabel;
@end

@implementation EstimatedEarningCell

+ (CGFloat)height {
    return 44.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValues:(NSDictionary *)values {
    self.periodLabel.text = values[@"period"];
    if (values[@"isHeader"]) {
        self.currencyLabel.text = values[@"coins"];
        self.btcLabel.text = values[@"bitcoins"];
        self.usdLabel.text = values[@"dollars"];
    } else {
        self.currencyLabel.text = [NSString stringWithFormat:@"%.5f", [values[@"coins"] doubleValue]];
        self.btcLabel.text = [NSString stringWithFormat:@"%.5f", [values[@"bitcoins"] doubleValue]];
        self.usdLabel.text = [NSString stringWithFormat:@"%.2f", [values[@"dollars"] doubleValue]];
    }
}

@end
