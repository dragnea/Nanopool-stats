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
    return 65.0f;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(textFieldCell:textDidChanged:)]) {
        [self.delegate textFieldCell:self textDidChanged:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    }
    return YES;
}

@end
