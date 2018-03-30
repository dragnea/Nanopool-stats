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
#import "DBController.h"

@interface EstimatedCalculatorVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *hashesLabel;
@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property (nonatomic, weak) IBOutlet UIImageView *placeholderImageView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeholderTipsLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSMutableArray *earnings;
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
    
    Account *account = [Account entityInContext:[DBController mainContext] name:@"Account" key:@"address" value:self.address shouldCreate:NO];
    
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

- (void)reload {
    [self.loadingView startAnimating];
    [self showPlaceholder:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    if (!self.earnings) {
        self.earnings = [NSMutableArray array];
    } else {
        [self.earnings removeAllObjects];
    }
    Account *account = [Account entityInContext:[DBController mainContext] name:@"Account" key:@"address" value:self.address shouldCreate:NO];
    [[NanopoolController sharedInstance] estimatedEarningsForAccount:account completion:^(NSDictionary *response, NSString *errorString) {
        
        NSArray *keys = @[@{@"key": @"minute", @"value": @"Minute"},
                          @{@"key": @"hour", @"value": @"Hour"},
                          @{@"key": @"day", @"value": @"Day"},
                          @{@"key": @"week", @"value": @"Week"},
                          @{@"key": @"month", @"value": @"Month"}];
        
        [self.earnings addObject:@{@"period": @"Period", @"coins": [Account currencyForType:account.type], @"dollars": @"USD", @"bitcoins": @"BTC", @"isHeader": @YES}];
        
        for (NSDictionary *obj in keys) {
            NSMutableDictionary *values = [NSMutableDictionary dictionary];
            [values setDictionary:response[obj[@"key"]]];
            [values setValue:obj[@"value"] forKey:@"period"];
            [self.earnings addObject:values];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.earnings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EstimatedEarningCell *earningsCell = [EstimatedEarningCell cellInTableView:tableView forIndexPath:indexPath];
    earningsCell.values = self.earnings[indexPath.row];
    return earningsCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EstimatedEarningCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
