//
//  ViewController.m
//  Demo1
//
//  Created by wayne on 15/7/14.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController () <ABPeoplePickerNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
{
    NSMutableArray *dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tableView.delegate = (id<UITableViewDelegate>)self;
    _tableView.dataSource = (id<UITableViewDataSource>)self;
    
    dataSource = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapMeButtonOnClick:(UIButton *)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = (id<ABPeoplePickerNavigationControllerDelegate>)self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

// 点击联系人以后调用，调用完成以后页面 dismiss
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    [dataSource removeAllObjects];
    [self handlePersion:person];
    [_tableView reloadData];
    
}

/*
 // 点击联系人属性以后调用, 调用完成以后页面 dismiss
 - (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
 {
 }*/

/*
 // 点击取消按钮后调用。
 - (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
 {
 NSLog(@"%s", __PRETTY_FUNCTION__);
 }*/


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[dataSource objectAtIndex:indexPath.row] allKeys][0];
    cell.detailTextLabel.text = [[dataSource objectAtIndex:indexPath.row] allValues][0];
    NSLog(@"%@", [[dataSource objectAtIndex:indexPath.row] allValues][0]);
    return cell;
}

#pragma mark -
- (void)handlePersion:(ABRecordRef)person
{
    // 姓氏，名字，中间名，昵称，公司
    NSString *lastName      = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *firstName     = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *middleName    = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    NSString *nicName       = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonNicknameProperty);
    NSString *companyName     = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
    
    if (lastName) {
        [dataSource addObject:@{@"姓氏":lastName}];
    }
    
    if (firstName) {
        [dataSource addObject:@{@"名字":firstName}];
    }
    
    if (middleName) {
        [dataSource addObject:@{@"中间名":middleName}];
    }
    
    if (nicName) {
        [dataSource addObject:@{@"昵称":nicName}];
    }
    
    if (companyName) {
        [dataSource addObject:@{@"公司":companyName}];
    }
    
    // 电话号码相关
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex count = ABMultiValueGetCount(phoneNumbers);
    if (count > 0) {
        for (int i = 0; i < count; ++i) {
            NSString *phoneNumber = (__bridge_transfer NSString*)
            ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            NSString *phoneNumberLabel = (__bridge_transfer NSString*)
            ABMultiValueCopyLabelAtIndex(phoneNumbers, i);
            [dataSource addObject:@{phoneNumberLabel:companyName ?: phoneNumber}];
        }
    }
    
    // 其他
    NSString *email = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonEmailProperty);
    if (email) {
        [dataSource addObject:@{@"E-mail":email}];
    }
}

@end
