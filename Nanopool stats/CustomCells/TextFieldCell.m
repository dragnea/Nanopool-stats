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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.contentView.backgroundColor = [[UIColor themeColorBackground] colorWithAlphaComponent:0.1f];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.contentView.backgroundColor = [UIColor clearColor];
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

@end
