//
//  AccountDetailsVC.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/6/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AccountDetailsVC.h"

@interface AccountDetailsVC ()
@property (nonatomic, copy) NSString *address;
@end

@implementation AccountDetailsVC

- (id)initWithAddress:(NSString *)address {
    if (self = [super init]) {
        self.address = address;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Details";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
