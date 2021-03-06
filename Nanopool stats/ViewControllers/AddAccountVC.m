//
//  AddAccountVC.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AddAccountVC.h"
#import "TextFieldCell.h"
#import "AccountSelectCell.h"
#import "TableHeader.h"
#import "NanopoolController.h"

@interface AddAccountVC ()<UITableViewDataSource, UITableViewDelegate, TextFieldCellDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) AccountType accountType;

@end

@implementation AddAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add account";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(addAccount)];
    
    [TableHeader registerNibInTableView:self.tableView];
    [TextFieldCell registerNibInTableView:self.tableView];
    [AccountSelectCell registerNibInTableView:self.tableView];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)addAccount {
    [self.tableView endEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[NanopoolController sharedInstance] verifyAccountType:self.accountType address:self.address completion:^(NSString *errorString) {
        if (!errorString) {
            [[NanopoolController sharedInstance] addAccount:self.accountType address:self.address name:self.name];
            [self.delegate addAccountVC:self didAddAccountName:self.name address:self.address type:self.accountType];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New account" message:errorString preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return [Account types].count;
        default:
            return 0;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [TableHeader height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableHeader *headerView = [TableHeader headerInTableView:tableView];
    switch (section) {
        case 0:
            headerView.text = @"General informations";
            break;
        case 1:
            headerView.text = @"Select an account type";
            break;
        default:
            headerView.text = @"???";
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [TextFieldCell height];
        case 1:
            return [AccountSelectCell height];
        default:
            return 1.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TextFieldCell *textFieldCell = [TextFieldCell cellInTableView:tableView forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                textFieldCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                textFieldCell.textField.placeholder = @"Address";
                textFieldCell.textField.text = self.address;
                break;
            case 1:
                textFieldCell.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                textFieldCell.textField.placeholder = @"Name (optional)";
                textFieldCell.textField.text = self.name;
                break;
        }
        textFieldCell.delegate = self;
        return textFieldCell;
    } else if (indexPath.section == 1) {
        AccountSelectCell *accountSelectCell = [AccountSelectCell cellInTableView:tableView forIndexPath:indexPath];
        AccountType accountType = [[Account types][indexPath.row] integerValue];
        accountSelectCell.accountType = accountType;
        accountSelectCell.selected = (accountType == self.accountType);
        return accountSelectCell;
    } else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"errCell"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [[self.tableView cellForRowAtIndexPath:indexPath] becomeFirstResponder];
            break;
        case 1:
            self.accountType = [[Account types][indexPath.row] integerValue];
            self.navigationItem.rightBarButtonItem.enabled = (self.address.length && self.accountType);
            break;
        default:
            break;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

#pragma mark - TextFieldCellDelegate

- (void)textFieldCell:(TextFieldCell *)textFieldCell textDidChanged:(NSString *)text {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldCell];
    if (indexPath.row == 0) {
        self.address = text;
        self.navigationItem.rightBarButtonItem.enabled = (text.length && self.accountType);
    } else {
        self.name = text;
    }
}

- (void)textFieldCellDidReturn:(TextFieldCell *)textFieldCell {
    if (self.navigationItem.rightBarButtonItem.enabled) {
        [self addAccount];
    }
}

@end
