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
#import "AddAccountVC.h"
#import "NanopoolController.h"

@interface DashboardVC ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeholderDetailsLabel;
@property (nonatomic, weak) IBOutlet DMSButton *addButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonBottomConstraint;
@property (nonatomic, strong) NSFetchedResultsController *accountsFetchedResultsController;
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
    
    [AccountTypeHeader registerNibInTableView:self.tableView];
    [AccountStatsCell registerNibInTableView:self.tableView];
    
    NSFetchRequest *accountsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Account class])];
    accountsFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"balance" ascending:YES]];
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
    
    [[NanopoolController sharedInstance] updateAccounts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePlaceholder {
    BOOL showPlaceholder = !self.accountsFetchedResultsController.fetchedObjects.count;
    self.addButtonBottomConstraint.constant = showPlaceholder ? self.view.bounds.size.height / 2.0f + 80.0f : 20.0f;
    [UIView animateWithDuration:0.25f animations:^{
        self.placeholderTitleLabel.alpha = showPlaceholder;
        self.placeholderDetailsLabel.alpha = showPlaceholder;
        [self.view layoutIfNeeded];
    }];
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
   didChangeObject:(id)anObject
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
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self updatePlaceholder];
}

@end
