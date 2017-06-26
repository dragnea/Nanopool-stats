//
//  EstimatedCalculatorVC.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "EstimatedCalculatorVC.h"
#import "NanopoolController.h"
#import "TableHeader.h"
#import "EstimatedEarningCell.h"

@interface EstimatedCalculatorVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *warningLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSDictionary *earnings;
@end

@implementation EstimatedCalculatorVC

- (id)initWithAddress:(NSString *)address {
    if (self = [super init]) {
        self.address = address;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Very approximated earnings";
    self.warningLabel.text = @"EXPERIMENTAL. Calculated based on average block time, average difficulty, difficulty change tendency and your average hashrate for last 6 hours.";
    
    self.warningLabel.textColor = [UIColor whiteColor];
    self.warningLabel.backgroundColor = [UIColor themeColorBackground];
    
    [TableHeader registerNibInTableView:self.tableView];
    [EstimatedEarningCell registerNibInTableView:self.tableView];
    
    [[NanopoolController sharedInstance] estimatedEarningsForAddress:self.address completion:^(NSDictionary *result) {
        if ([result[@"status"] boolValue]) {
            self.earnings = result;
        } else {
            self.earnings = nil;
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)nameForSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"minute";
        case 1:
            return @"hour";
        case 2:
            return @"day";
        case 3:
            return @"week";
        case 4:
            return @"month";
            
        default:
            return nil;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return !self.earnings ? 0 : 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableHeader *headerView = [TableHeader headerFooterInTableView:tableView];
    headerView.text = [[self nameForSection:section] uppercaseString];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EstimatedEarningCell *earningsCell = [EstimatedEarningCell cellInTableView:tableView forIndexPath:indexPath];
    
    return earningsCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [TableHeader height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
