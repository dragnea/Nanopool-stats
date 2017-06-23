//
//  WorkersVC.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/22/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "WorkersVC.h"
#import "Worker.h"
#import "CoreData.h"
#import "WorkerCell.h"

@interface WorkersVC ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController <Worker *> *workersFetchedController;
@end

@implementation WorkersVC

- (id)initWithAddress:(NSString *)address {
    if (self = [super init]) {
        NSFetchRequest *workersFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Worker class])];
        workersFetchRequest.predicate = [NSPredicate predicateWithFormat:@"account.address == %@", address];
        workersFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastShare" ascending:NO]];
        self.workersFetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:workersFetchRequest
                                                                            managedObjectContext:[CoreData mainContext]
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Workers";
    [WorkerCell registerNibInTableView:self.tableView];
    
    NSError *error = nil;
    if (![self.workersFetchedController performFetch:&error]) {
        NSLog(@"WorkersVC: error fetching workers: %@", error.localizedDescription);
    } else {
        self.workersFetchedController.delegate = self;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.workersFetchedController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workersFetchedController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkerCell *workerCell = [WorkerCell cellInTableView:tableView forIndexPath:indexPath];
    workerCell.worker = [self.workersFetchedController objectAtIndexPath:indexPath];
    return workerCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WorkerCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

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

@end
