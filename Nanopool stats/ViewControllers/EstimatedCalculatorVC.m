//
//  EstimatedCalculatorVC.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "EstimatedCalculatorVC.h"
#import "NanopoolController.h"
#import "EstimatedEarningCell.h"
#import "CoreData.h"

@interface EstimatedCalculatorVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *hashesLabel;
@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *warningLabel;
@property (nonatomic, weak) IBOutlet UIImageView *placeholderImageView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeholderTipsLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;
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
    
    self.navigationItem.title = @"Earnings";
    self.warningLabel.text = @"EXPERIMENTAL. Calculated based on average block time, average difficulty, difficulty change tendency and your average hashrate for last 6 hours.";
    
    Account *account = [Account entityInContext:[CoreData mainContext] key:@"address" value:self.address shouldCreate:NO];
    
    self.warningLabel.textColor = [UIColor whiteColor];
    self.headerView.backgroundColor = [UIColor themeColorBackground];
    self.hashesLabel.text = [NSString stringWithFormat:@"%.2f %@", account.hashrate, [Account unitForType:account.type]];
    self.currencyLabel.text = [Account currencyForType:account.type];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(reload)];
    
    [EstimatedEarningCell registerNibInTableView:self.tableView];
    
    [self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.headerViewHeightConstraint.constant = [self.warningLabel.text boundingRectWithSize:CGSizeMake(self.warningLabel.bounds.size.width, 200.0f)
                                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                                 attributes:@{NSFontAttributeName: self.warningLabel.font}
                                                                                    context:nil].size.height + self.hashesLabel.bounds.size.height + 25.0f;
}

- (void)reload {
    [self.loadingView startAnimating];
    [self showPlaceholder:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[NanopoolController sharedInstance] estimatedEarningsForAddress:self.address completion:^(NSDictionary *result) {
        if ([result[@"status"] boolValue]) {
            self.earnings = result[@"data"];
        } else {
            self.earnings = nil;
        }
        [self.tableView reloadData];
        [self.loadingView stopAnimating];
        [self showPlaceholder:!self.earnings.count];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)showPlaceholder:(BOOL)showPlaceholder {
    self.placeholderImageView.hidden = !showPlaceholder;
    self.placeholderLabel.hidden = self.placeholderImageView.hidden;
    self.placeholderTipsLabel.hidden = self.placeholderImageView.hidden;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EstimatedEarningCell *earningsCell = [EstimatedEarningCell cellInTableView:tableView forIndexPath:indexPath];
    NSString *sectionKey = [self nameForSection:indexPath.section];
    earningsCell.values = self.earnings[sectionKey];
    earningsCell.periodLabel.text = sectionKey.uppercaseString;
    return earningsCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
