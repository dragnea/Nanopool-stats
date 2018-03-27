//
//  TextFieldCell.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldCell;

@protocol TextFieldCellDelegate <NSObject>

- (void)textFieldCell:(TextFieldCell *)textFieldCell textDidChanged:(NSString *)text;
- (void)textFieldCellDidReturn:(TextFieldCell *)textFieldCell;

@end

@interface TextFieldCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) id<TextFieldCellDelegate>delegate;
+ (CGFloat)height;
@end
