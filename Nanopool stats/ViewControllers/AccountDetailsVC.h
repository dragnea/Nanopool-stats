//
//  AccountDetailsVC.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/6/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountDetailsVC : UIViewController
@property (nonatomic, strong) NSString *address;

- (void)reloadAll;
- (id)initWithAddress:(NSString *)address;

@end
