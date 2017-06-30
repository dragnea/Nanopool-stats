//
//  DashboardVC.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "DashboardVC.h"
#import "AccountTypeHeader.h"
#import "AccountStatsCell.h"
#import "Account.h"
#import "CoreData.h"
#import "NanopoolController.h"
#import "AddAccountVC.h"
#import "AccountDetailsVC.h"
#import "Reachability.h"

@interface DashboardVC ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeholderDetailsLabel;
@property (nonatomic, weak) IBOutlet DMSButton *addButton;
@property (nonatomic, strong) NSFetchedResultsController <Account *>*accountsFetchedResultsController;
@property (nonatomic, weak) AccountDetailsVC *accountDetailsVC;
@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) Reachability *reachability;
@end

@implementation DashboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Dashboard";
    self.view.backgroundColor = [UIColor themeColorBackground];
    self.placeholderTitleLabel.textColor = [UIColor whiteColor];
    self.placeholderDetailsLabel.textColor = [[UIColor whiteColor] themeColorWithValueTitleAlpha];
    self.addButton.backgroundColor = [UIColor whiteColor];
    [self.addButton setTitleColor:[UIColor themeColorBackground] forState:UIControlStateNormal];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 88.0f, 0.0f);
    
    [AccountTypeHeader registerNibInTableView:self.tableView];
    [AccountStatsCell registerNibInTableView:self.tableView];
    
    NSFetchRequest *accountsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Account class])];
    accountsFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES],
                                             [NSSortDescriptor sortDescriptorWithKey:@"balance" ascending:YES]];
    NSError *error = nil;
    self.accountsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:accountsFetchRequest
                                                                                managedObjectContext:[CoreData mainContext]
                                                                                  sectionNameKeyPath:@"type"
                                                                                           cacheName:nil];
    if (![self.accountsFetchedResultsController performFetch:&error]) {
        // TODO: add error handling
    } else {
        self.accountsFetchedResultsController.delegate = self;
        [self updatePlaceholder];
        [self.tableView reloadData];
    }
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityNotification:) name:kReachabilityChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.refreshTimer) {
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
    }
    [self.refreshTimer fire];
    [self.reachability startNotifier];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
    [self.reachability stopNotifier];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateAccounts {
    if ([self.reachability currentReachabilityStatus] != NotReachable) {
        [[NanopoolController sharedInstance] updateAccounts:nil];
    }
}

- (void)refresh:(NSTimer *)timer {
    [self updateAccounts];
}

- (void)reachabilityNotification:(NSNotification *)notification {
    [self updateAccounts];
}

- (void)updatePlaceholder {
    BOOL showPlaceholder = !self.accountsFetchedResultsController.fetchedObjects.count;
    self.placeholderTitleLabel.alpha = showPlaceholder;
    self.placeholderDetailsLabel.alpha = showPlaceholder;
}

- (IBAction)addCcountButtonTouched:(id)sender {
    [self.navigationController pushViewController:[[AddAccountVC alloc] init] animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.accountsFetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountsFetchedResultsController.sections[section].numberOfObjects;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [AccountTypeHeader height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AccountStatsCell heigth];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AccountTypeHeader *headerView = [AccountTypeHeader headerFooterInTableView:tableView];
    headerView.accountType = [self.accountsFetchedResultsController.sections[section].name integerValue];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountStatsCell *accountCell = [AccountStatsCell cellInTableView:tableView forIndexPath:indexPath];
    accountCell.account = [self.accountsFetchedResultsController objectAtIndexPath:indexPath];
    return accountCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *address = [self.accountsFetchedResultsController objectAtIndexPath:indexPath].address;
    AccountDetailsVC *accountDetailsVC = [[AccountDetailsVC alloc] initWithAddress:address];
    [self.navigationController pushViewController:accountDetailsVC animated:YES];
    self.accountDetailsVC = accountDetailsVC;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(Account *)account
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
    
    if ([account.address isEqualToString:self.accountDetailsVC.address]) {
        if (type == NSFetchedResultsChangeDelete) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.accountDetailsVC reloadAll];
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self updatePlaceholder];
}

@end
