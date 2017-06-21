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

typedef NS_ENUM(NSInteger, Section) {
    SectionName = 0,
    SectionAverages = 1,
    SectionHashrateGraph = 2
};

@interface AccountDetailsVC ()<UITableViewDataSource, UITableViewDelegate, HorizontalSelectCellDelegate, TextFieldCellDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) Account *account;

@property (nonatomic, strong) NSArray <HorizontalSelectCellItem *> *avgHashrates;
@property (nonatomic, strong) NSMutableArray <GraphCellItem*> *hashrates;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
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
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.numberFormatter.usesGroupingSeparator = NO;
    self.numberFormatter.minimumFractionDigits = 1;
    self.numberFormatter.maximumFractionDigits = 2;
    self.numberFormatter.positiveSuffix = @" MH/s";
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    [self reloadAll];
    
    [TableHeader registerNibInTableView:self.tableView];
    [TextFieldCell registerNibInTableView:self.tableView];
    [HorizontalSelectCell registerNibInTableView:self.tableView];
    [GraphCell registerNibInTableView:self.tableView];
    [[NanopoolController sharedInstance] updateHashrateHistoryForAccount:self.account completion:^(NSString *error) {
        [self reloadAll];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadAll {
    [self reloadAverage];
    [self reloadHashrates];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionName:
            return 1;
        case SectionAverages:
            return 1;
        case SectionHashrateGraph:
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
        case SectionName:
            switch (indexPath.row) {
                case 0:
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
    }
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableHeader *headerView = [TableHeader headerFooterInTableView:tableView];
    switch (section) {
        case SectionName:
            headerView.text = @"General informations";
            break;
        case SectionAverages:
            headerView.text = @"Calculated average hashrate";
            break;
        case SectionHashrateGraph:
            headerView.text = @"Hashrate MH/s";
            break;
        default:
            headerView.text = @"???";
            break;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionName) {
        if (indexPath.row == 0) {
            TextFieldCell *nameTextFieldCell = [TextFieldCell cellInTableView:tableView forIndexPath:indexPath];
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
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"errCell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
