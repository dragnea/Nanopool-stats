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
#import "NanopoolController.h"

@interface AddAccountVC ()<UITableViewDataSource, UITableViewDelegate, TextFieldCellDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) AccountType accountType;

@end

@implementation AddAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TextFieldCell registerNibInTableView:self.tableView];
    [AccountSelectCell registerNibInTableView:self.tableView];
    
    self.addButton.enabled = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonTouched:(id)sender {
    [[NanopoolController sharedInstance] addAccountWithType:self.accountType name:self.name address:self.address completion:^(NSString *error) {
        if (error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Account cannot be addded" message:error preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController: alertController animated:YES completion:nil];
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
    return 40.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"General informations";
        case 1:
            return @"Select an account type";
        default:
            return nil;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TextFieldCell *textFieldCell = [TextFieldCell cellInTableView:tableView forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                textFieldCell.textField.placeholder = @"Name (optional)";
                textFieldCell.textField.text = self.name;
                break;
            case 1:
                textFieldCell.textField.placeholder = @"Address";
                textFieldCell.textField.text = self.address;
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
        return [UITableViewCell dummyTableViewCell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [[self.tableView cellForRowAtIndexPath:indexPath] becomeFirstResponder];
            break;
        case 1:
            self.accountType = [[Account types][indexPath.row] integerValue];
            self.addButton.enabled = (self.address.length && self.accountType);
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
        self.name = text;
    } else {
        self.address = text;
        self.addButton.enabled = (text.length && self.accountType);
    }
}

@end
