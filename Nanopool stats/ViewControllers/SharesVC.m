//
//  SharesVC.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/26/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "SharesVC.h"
#import "ShareCell.h"
#import "Share.h"
#import "DBController.h"

@interface SharesVC ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *placeholderImageView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeholderTipsLabel;
@property (nonatomic, strong) NSFetchedResultsController <Share *> *sharesFetchedController;
@end

@implementation SharesVC

- (id)initWithAddress:(NSString *)address {
    if (self = [super init]) {
        NSFetchRequest *sharesFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Share class])];
        sharesFetchRequest.predicate = [NSPredicate predicateWithFormat:@"account.address == %@", address];
        sharesFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        self.sharesFetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:sharesFetchRequest
                                                                             managedObjectContext:[DBController mainContext]
                                                                               sectionNameKeyPath:nil
                                                                                        cacheName:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Shares";
    [ShareCell registerNibInTableView:self.tableView];
    NSError *error = nil;
    if (![self.sharesFetchedController performFetch:&error]) {
        NSLog(@"WorkersVC: error fetching workers: %@", error.localizedDescription);
    } else {
        self.sharesFetchedController.delegate = self;
        [self.tableView reloadData];
        [self updatePlaceholder];
    }
    
    UIColor *placeholderColor = [[UIColor blackColor] themeColorWithValueTitleAlpha];
    self.placeholderImageView.tintColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
    self.placeholderTipsLabel.textColor = placeholderColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePlaceholder {
    self.placeholderImageView.hidden = self.sharesFetchedController.fetchedObjects.count != 0;
    self.placeholderLabel.hidden = self.placeholderImageView.hidden;
    self.placeholderTipsLabel.hidden = self.placeholderImageView.hidden;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sharesFetchedController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sharesFetchedController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell *shareCell = [ShareCell cellInTableView:tableView forIndexPath:indexPath];
    shareCell.share = [self.sharesFetchedController objectAtIndexPath:indexPath];
    return shareCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ShareCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
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
