//
//  WorkerCell.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/22/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "WorkerCell.h"
#import "Worker.h"

@interface WorkerCell ()
@property (nonatomic, weak) IBOutlet UILabel *idLabel;
@property (nonatomic, weak) IBOutlet UILabel *hashrateLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastShareLabel;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation WorkerCell

+ (CGFloat)height {
    return 80.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.numberFormatter.usesGroupingSeparator = NO;
    self.numberFormatter.minimumFractionDigits = 1;
    self.numberFormatter.maximumFractionDigits = 8;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWorker:(Worker *)worker {
    _worker = worker;
    self.idLabel.text = worker.id;
    self.hashrateLabel.text = [NSString stringWithFormat:@"%@ MH/s", [self.numberFormatter stringFromNumber:@(worker.hashrate)]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:worker.lastShare];
    self.lastShareLabel.text = [self.dateFormatter stringFromDate:date];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [[UIColor themeColorBackground] themeColorWithSeparatorAlpha].CGColor);
    CGContextMoveToPoint(context, 0.0f, rect.size.height - 1.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1.0f);
    CGContextStrokePath(context);
}

@end
