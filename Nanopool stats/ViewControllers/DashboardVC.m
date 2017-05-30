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

@interface DashboardVC ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *accountsFetchedResultsController;
@end

@implementation DashboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AccountTypeHeader registerNibInTableView:self.tableView];
    [AccountStatsCell registerNibInTableView:self.tableView];
    
    NSFetchRequest *accountsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Account class])];
    accountsFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"balance" ascending:YES]];
    NSError *error = nil;
    self.accountsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:accountsFetchRequest
                                                                                managedObjectContext:[CoreData mainContext]
                                                                                  sectionNameKeyPath:@"currencyName"
                                                                                           cacheName:nil];
    if (![self.accountsFetchedResultsController performFetch:&error]) {
        // TODO: add error handling
    } else {
        self.accountsFetchedResultsController.delegate = self;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePlaceholder {
    
}

- (IBAction)addCcountButtonTouched:(id)sender {
    [self presentViewController:[[AddAccountVC alloc] init] animated:YES completion:nil];
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
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AccountTypeHeader *headerView = [AccountTypeHeader headerFooterInTableView:tableView];
    headerView.currencyName = self.accountsFetchedResultsController.sections[section].name;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountStatsCell *accountCell = [AccountStatsCell cellInTableView:tableView forIndexPath:indexPath];
    accountCell.account = [self.accountsFetchedResultsController objectAtIndexPath:indexPath];
    return accountCell;
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
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
