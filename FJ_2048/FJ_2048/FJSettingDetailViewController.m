
//
//  FJSettingDetailViewController.m
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/8.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJSettingDetailViewController.h"

@implementation FJSettingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [GSTATE scoreBoardColor];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Setting Detail Cell"];
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    cell.accessoryType = ([SETTING integerForKey:self.title] == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.tintColor = [GSTATE scoreBoardColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SETTING setInteger:indexPath.row forKey:self.title];
    [self.tableView reloadData];
    GSTATE.needRefresh = YES;
}
@end
