//
//  TextFieldCell.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "TextFieldCell.h"

@interface TextFieldCell ()<UITextFieldDelegate>

@end

@implementation TextFieldCell

+ (CGFloat)height {
    return 50.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.contentView.backgroundColor = [[UIColor themeColorBackground] colorWithAlphaComponent:0.1f];
    [self setNeedsDisplay];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.contentView.backgroundColor = [UIColor clearColor];
    [self setNeedsDisplay];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(textFieldCell:textDidChanged:)]) {
        [self.delegate textFieldCell:self textDidChanged:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldCellDidReturn:)]) {
        [self.delegate textFieldCellDidReturn:self];
    }
    return YES;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, (self.textField.isFirstResponder ? 3.0f : 1.0f)/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor themeColorBackground].CGColor);
    // draw bottom line
    CGContextMoveToPoint(context, 0.0f, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    // draw text field bottom border
    UIColor *borderColor = [UIColor themeColorBackground];
    CGRect borderFrame = CGRectInset(self.textField.frame, -6.0f, 0.0f);
    CGContextSetStrokeColorWithColor(context, (self.textField.isFirstResponder ? borderColor : [borderColor themeColorWithSeparatorAlpha]).CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX(borderFrame), CGRectGetMaxY(self.textField.frame) - 8.0f);
    CGContextAddLineToPoint(context, CGRectGetMinX(borderFrame), CGRectGetMaxY(self.textField.frame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(borderFrame), CGRectGetMaxY(self.textField.frame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(borderFrame), CGRectGetMaxY(self.textField.frame) - 8.0f);
    CGContextStrokePath(context);
}

@end
