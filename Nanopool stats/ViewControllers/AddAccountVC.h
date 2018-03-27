//
//  AddAccountVC.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddAccountVC;

@protocol AddAccountVCDelegate <NSObject>
- (void)addAccountVC:(AddAccountVC *)addAccountVC didAddAccountName:(NSString *)name address:(NSString *)address type:(int16_t)type;
@end

@interface AddAccountVC : UIViewController
@property (nonatomic, weak) id<AddAccountVCDelegate>delegate;

@end
