//
//  PaymentsVC.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 6/24/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "PaymentsVC.h"
#import "Payment.h"
#import "DBController.h"
#import "PaymentCell.H"

@interface PaymentsVC ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *placeholderImageView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeholderTipsLabel;
@property (nonatomic, strong) NSFetchedResultsController <Payment *> *paymentsFetchedController;
@end

@implementation PaymentsVC

- (id)initWithAddress:(NSString *)address {
    if (self = [super init]) {
        NSFetchRequest *paymentsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Payment class])];
        paymentsFetchRequest.predicate = [NSPredicate predicateWithFormat:@"account.address == %@", address];
        paymentsFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        self.paymentsFetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:paymentsFetchRequest
                                                                            managedObjectContext:[DBController mainContext]
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"Payments";
    [PaymentCell registerNibInTableView:self.tableView];
    NSError *error = nil;
    if (![self.paymentsFetchedController performFetch:&error]) {
        NSLog(@"WorkersVC: error fetching workers: %@", error.localizedDescription);
    } else {
        self.paymentsFetchedController.delegate = self;
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
    self.placeholderImageView.hidden = self.paymentsFetchedController.fetchedObjects.count != 0;
    self.placeholderLabel.hidden = self.placeholderImageView.hidden;
    self.placeholderTipsLabel.hidden = self.placeholderImageView.hidden;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.paymentsFetchedController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paymentsFetchedController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentCell *paymentCell = [PaymentCell cellInTableView:tableView forIndexPath:indexPath];
    paymentCell.payment = [self.paymentsFetchedController objectAtIndexPath:indexPath];
    return paymentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PaymentCell height];
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
