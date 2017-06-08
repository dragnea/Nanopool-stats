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
#import "HashrateGraphCell.h"
#import "TableHeader.h"
#import "NanopoolController.h"

@interface AccountDetailsVC ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) Account *account;
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
    
    self.title = @"Account details";
    
    [TableHeader registerNibInTableView:self.tableView];
    [AverageHashratesCell registerNibInTableView:self.tableView];
    [HashrateGraphCell registerNibInTableView:self.tableView];
    [[NanopoolController sharedInstance] updateHashrateHistoryForAccount:self.account completion:^(NSString *error) {
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSError *error;
    if (![[CoreData mainContext] save:&error]) {
        NSLog(@"err: %@", error.localizedDescription);
    }
}

- (Account *)account {
    return [Account entityInContext:[CoreData mainContext] key:@"address" value:self.address shouldCreate:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
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
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return [AverageHashratesCell height];
                default:
                    return 1.0f;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    return [HashrateGraphCell height];
                default:
                    return 1.0f;
            }
        default:
            return 1.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableHeader *headerView = [TableHeader headerFooterInTableView:tableView];
    switch (section) {
        case 0:
            headerView.text = @"Calculated average hashrate";
            break;
        case 1:
            headerView.text = @"Hashrate MH/s";
            break;
        default:
            headerView.text = @"???";
            break;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AverageHashratesCell *averageCell = [AverageHashratesCell cellInTableView:tableView forIndexPath:indexPath];
            averageCell.account = self.account;
            return averageCell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            HashrateGraphCell *hashrateGraphCell = [HashrateGraphCell cellInTableView:tableView forIndexPath:indexPath];
            hashrateGraphCell.account = self.account;
            return hashrateGraphCell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"errCell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
