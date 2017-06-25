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
#import "HorizontalSelectCell.h"
#import "GraphCell.h"
#import "TableHeader.h"
#import "NanopoolController.h"
#import "TextFieldCell.h"
#import "InfoDetailsCell.h"
#import "WorkersVC.h"
#import "AccountInfoCell.h"
#import "PaymentsVC.h"

typedef NS_ENUM(NSInteger, Section) {
    SectionGeneralInfo = 0,
    SectionAverages,
    SectionHashrateGraph,
    SectionWorkers,
    SectionPayments,
    SectionShares,
    SectionCalculator
};

@interface AccountDetailsVC ()<UITableViewDataSource, UITableViewDelegate, HorizontalSelectCellDelegate, TextFieldCellDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Account *account;

@property (nonatomic, strong) NSArray <HorizontalSelectCellItem *> *avgHashrates;
@property (nonatomic, strong) NSMutableArray <GraphCellItem*> *hashrates;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation AccountDetailsVC {
    NSString *kAccountAddressText;
    NSString *kBalanceText;
}

- (id)initWithAddress:(NSString *)address {
    if (self = [super init]) {
        
        self.address = address;
        kAccountAddressText = @"Account address";
        kBalanceText = @"Balance";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Account details";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(moreButtonTouched:)];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.numberFormatter.usesGroupingSeparator = NO;
    self.numberFormatter.minimumFractionDigits = 1;
    self.numberFormatter.maximumFractionDigits = 2;
    self.numberFormatter.positiveSuffix = @" MH/s";
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    [self reloadAll];
    
    [TableHeader registerNibInTableView:self.tableView];
    [TextFieldCell registerNibInTableView:self.tableView];
    [HorizontalSelectCell registerNibInTableView:self.tableView];
    [GraphCell registerNibInTableView:self.tableView];
    [InfoDetailsCell registerNibInTableView:self.tableView];
    [AccountInfoCell registerNibInTableView:self.tableView];
    [[NanopoolController sharedInstance] updateHashrateHistoryForAccount:self.account completion:^(NSString *error) {
        [self reloadAll];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moreButtonTouched:(UIBarButtonItem *)barButton {
    
}

- (HorizontalSelectCellItem *)avgHashrateWithAvgHour:(AccountAvgHour)accountAvgHour {
    return [[HorizontalSelectCellItem alloc] initWithTitle:[self.account avgHashrateTitleForHour:accountAvgHour]
                                                     value:[self.numberFormatter stringFromNumber:@([self.account avgHashrateForHour:accountAvgHour])]];
}

- (void)reloadAverage {
    NSNumber *avgAllHashrates = [self.account.hashrateHistory valueForKeyPath:@"@avg.hashrate"];
    self.avgHashrates = @[[self avgHashrateWithAvgHour:AccountAvgHour1h],
                          [self avgHashrateWithAvgHour:AccountAvgHour3h],
                          [self avgHashrateWithAvgHour:AccountAvgHour6h],
                          [self avgHashrateWithAvgHour:AccountAvgHour12h],
                          [self avgHashrateWithAvgHour:AccountAvgHour24h],
                          [[HorizontalSelectCellItem alloc] initWithTitle:@"All" value:[self.numberFormatter stringFromNumber:avgAllHashrates]]];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadHashrates {
    NSInteger hashratesCount = self.account.hashrateHistory.count;
    NSDate *minDate;
    switch (self.account.selectedAvgHashrateIndex) {
        case AccountAvgHour3h: // 3 hours
            minDate = [NSDate dateWithTimeIntervalSinceNow:-10800];
            break;
        case AccountAvgHour6h: // 6 hours
            minDate = [NSDate dateWithTimeIntervalSinceNow:-21600];
            break;
        case AccountAvgHour12h: // 12 hours
            minDate = [NSDate dateWithTimeIntervalSinceNow:-43200];
            break;
        case AccountAvgHour24h: // 24 hours
            minDate = [NSDate dateWithTimeIntervalSinceNow:-86400];
            break;
        case AccountAvgHourAll: // all hashrates
            minDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
            break;
        default: // 1 hour
            minDate = [NSDate dateWithTimeIntervalSinceNow:-3600];
            break;
    }
    self.hashrates = [NSMutableArray array];
    NSArray <NSDictionary *> *hashrateHistory = self.account.hashrateHistory;
    for (NSInteger index = 0; index < hashratesCount; index++) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[hashrateHistory[index][@"date"] doubleValue]];
        if ([date compare:minDate] == NSOrderedDescending) {
            CGFloat hashrate = [hashrateHistory[index][@"hashrate"] floatValue];
            [self.hashrates addObject:[[GraphCellItem alloc] initWithTitle:[self.dateFormatter stringFromDate:date] value:hashrate]];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:SectionHashrateGraph]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadAll {
    _account = [Account entityInContext:[CoreData mainContext] key:@"address" value:self.address shouldCreate:NO];
    [self reloadAverage];
    [self reloadHashrates];
}

- (void)dealloc {
    NSError *error;
    if (![[CoreData mainContext] save:&error]) {
        NSLog(@"err: %@", error.localizedDescription);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionGeneralInfo:
            return 3;
        case SectionAverages:
            return 1;
        case SectionHashrateGraph:
            return 1;
        case SectionWorkers:
            return 1;
        case SectionPayments:
            return 1;
        case SectionShares:
            return 1;
        case SectionCalculator:
            return 1;
        default:
            return 0;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [TableHeader height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionGeneralInfo:
            switch (indexPath.row) {
                case 0:
                    return [AccountInfoCell heightInTableView:tableView title:kAccountAddressText value:self.account.address];
                case 1:
                    return [AccountInfoCell height];
                case 2:
                    return [TextFieldCell height];
            }
            break;
        case SectionAverages:
            switch (indexPath.row) {
                case 0:
                    return [HorizontalSelectCell height];
            }
            break;
        case SectionHashrateGraph:
            switch (indexPath.row) {
                case 0:
                    return [GraphCell height];
            }
        case SectionWorkers:
            switch (indexPath.row) {
                case 0:
                    return [InfoDetailsCell height];
            }
        case SectionPayments:
            switch (indexPath.row) {
                case 0:
                    return [InfoDetailsCell height];
            }
        case SectionShares:
            switch (indexPath.row) {
                case 0:
                    return [InfoDetailsCell height];
            }
        case SectionCalculator:
            switch (indexPath.row) {
                case 0:
                    return [InfoDetailsCell height];
            }
    }
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableHeader *headerView = [TableHeader headerFooterInTableView:tableView];
    switch (section) {
        case SectionGeneralInfo:
            headerView.text = @"General informations";
            break;
        case SectionAverages:
            headerView.text = @"Calculated average hashrate";
            break;
        case SectionHashrateGraph:
            headerView.text = @"Hashrate MH/s";
            break;
        case SectionWorkers:
            headerView.text = @"Workers";
            break;
        case SectionPayments:
            headerView.text = @"Payments";
            break;
        case SectionShares:
            headerView.text = @"Shares";
            break;
        case SectionCalculator:
            headerView.text = @"Calculator";
            break;
        default:
            headerView.text = @"???";
            break;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionGeneralInfo) {
        if (indexPath.row == 0) {
            AccountInfoCell *addressInfoCell = [AccountInfoCell cellInTableView:tableView forIndexPath:indexPath];
            addressInfoCell.titleLabel.text = @"Account address";
            addressInfoCell.valueLabel.text = self.account.address;
            return addressInfoCell;
        } else if (indexPath.row == 1) {
            AccountInfoCell *balanceInfoCell = [AccountInfoCell cellInTableView:tableView forIndexPath:indexPath];
            balanceInfoCell.titleLabel.text = @"Balance";
            balanceInfoCell.valueLabel.text = [NSString stringWithFormat:@"%f %@", self.account.balance, [Account currencyForType:self.account.type]];
            return balanceInfoCell;
        } else if (indexPath.row == 2) {
            TextFieldCell *nameTextFieldCell = [TextFieldCell cellInTableView:tableView forIndexPath:indexPath];
            nameTextFieldCell.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            nameTextFieldCell.textField.text = self.account.name;
            nameTextFieldCell.textField.placeholder = @"No account name (optional)";
            nameTextFieldCell.delegate = self;
            return nameTextFieldCell;
        }
    } else if (indexPath.section == SectionAverages) {
        if (indexPath.row == 0) {
            HorizontalSelectCell *avgHashrateSelectCell = [HorizontalSelectCell cellInTableView:tableView forIndexPath:indexPath];
            avgHashrateSelectCell.items = self.avgHashrates;
            avgHashrateSelectCell.selectedItemIndex = self.account.selectedAvgHashrateIndex;
            avgHashrateSelectCell.delegate = self;
            return avgHashrateSelectCell;
        }
    } else if (indexPath.section == SectionHashrateGraph) {
        if (indexPath.row == 0) {
            GraphCell *hashrateCell = [GraphCell cellInTableView:tableView forIndexPath:indexPath];
            hashrateCell.items = self.hashrates;
            return hashrateCell;
        }
    } else if (indexPath.section == SectionWorkers) {
        if (indexPath.row == 0) {
            InfoDetailsCell *workersInfoCell = [InfoDetailsCell cellInTableView:tableView forIndexPath:indexPath];
            NSInteger workersCount = self.account.workers.count;
            if (!workersCount) {
                workersInfoCell.infoText = @"No workers yet";
            } else if (workersCount == 1) {
                workersInfoCell.infoText = @"See your worker";
            } else {
                workersInfoCell.infoText = [NSString stringWithFormat:@"See all %d workers", (int)workersCount];
            }
            return workersInfoCell;
        }
    } else if (indexPath.section == SectionPayments) {
        if (indexPath.row == 0) {
            InfoDetailsCell *paymentsInfoCell = [InfoDetailsCell cellInTableView:tableView forIndexPath:indexPath];
            NSInteger paymentsCount = self.account.payments.count;
            if (!paymentsCount) {
                paymentsInfoCell.infoText = @"No payments yet";
            } else if (paymentsCount == 1) {
                paymentsInfoCell.infoText = @"See the payment";
            } else {
                paymentsInfoCell.infoText = [NSString stringWithFormat:@"See all %d payments", (int)paymentsCount];
            }
            return paymentsInfoCell;
        }
    } else if (indexPath.section == SectionShares) {
        if (indexPath.row == 0) {
            InfoDetailsCell *sharesInfoCell = [InfoDetailsCell cellInTableView:tableView forIndexPath:indexPath];
            sharesInfoCell.infoText = [NSString stringWithFormat:@"%d average", (int)0];
            NSInteger sharesCount = self.account.shares.count;
            if (!sharesCount) {
                sharesInfoCell.infoText = @"No shares yet";
            } else if (sharesCount == 1) {
                sharesInfoCell.infoText = @"See the share";
            } else {
                sharesInfoCell.infoText = [NSString stringWithFormat:@"See all %d shares", (int)sharesCount];
            }
            return sharesInfoCell;
        }
    } else if (indexPath.section == SectionCalculator) {
        if (indexPath.row == 0) {
            InfoDetailsCell *calculatorInfoCell = [InfoDetailsCell cellInTableView:tableView forIndexPath:indexPath];
            calculatorInfoCell.infoText = [NSString stringWithFormat:@"%f per month", 0.0f];
            return calculatorInfoCell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"errCell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == SectionWorkers) {
        WorkersVC *workersVC = [[WorkersVC alloc] initWithAddress:self.account.address];
        [self.navigationController pushViewController:workersVC animated:YES];
    } else if (indexPath.section == SectionPayments) {
        PaymentsVC *paymentsVC = [[PaymentsVC alloc] initWithAddress:self.account.address];
        [self.navigationController pushViewController:paymentsVC animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

#pragma mark - HorizontalSelectCellDelegate

- (void)horizontalSelectCell:(HorizontalSelectCell *)horizontalSelectCell didSelectItemAtIndex:(NSInteger)index {
    self.account.selectedAvgHashrateIndex = index;
    [self reloadHashrates];
}

#pragma mark - TextFieldCellDelegate

- (void)textFieldCellDidReturn:(TextFieldCell *)textFieldCell {
    [textFieldCell resignFirstResponder];
}

- (void)textFieldCell:(TextFieldCell *)textFieldCell textDidChanged:(NSString *)text {
    self.account.name = text;
}

@end
