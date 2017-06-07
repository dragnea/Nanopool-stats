//
//  AccountDetailsVC.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/6/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AccountDetailsVC.h"
#import "Account.h"
#import "CoreData.h"
#import "AverageHashratesCell.h"
#import "TableHeader.h"

@interface AccountDetailsVC ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) Account *account;
@end

@implementation AccountDetailsVC

- (id)initWithAddress:(NSString *)address {
    if (self = [super init]) {
        self.address = address;
        self.account = [Account entityInContext:[CoreData mainContext] key:@"address" value:address shouldCreate:NO];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Account details";
    
    [TableHeader registerNibInTableView:self.tableView];
    [AverageHashratesCell registerNibInTableView:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        default:
            return 0;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AverageHashratesCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableHeader *headerView = [TableHeader headerFooterInTableView:tableView];
    headerView.text = @"Calculated average hashrate";
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AverageHashratesCell *averageCell = [AverageHashratesCell cellInTableView:tableView forIndexPath:indexPath];
    averageCell.account = self.account;
    return averageCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
