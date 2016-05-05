//
//  FJSettingViewController.m
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/8.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJSettingViewController.h"
#import "FJSettingDetailViewController.h"

@implementation FJSettingViewController
{
    IBOutlet UITableView *_tableView;
    NSArray *_options;
    NSArray *_optionSelections;
    NSArray *_optionsNotes;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    _options = @[@"Game Type", @"Board Size", @"Theme"];
    
    _optionSelections = @[@[@"Powers of 2", @"Powers of 3", @"Fibonacci"],@[@"3x3",@"4x4",@"5x5"],@[@"Default", @"Vibrant", @"Joyful"]];
    
    _optionsNotes = @[@"For Fibonacci games, a tile can be joined with a tile that is one level above or below it, but not to one equal to it. For Powers of 3, you need 3 consecutive tiles to be the same to trigger a merge!",
                      @"The smaller the board is, the harder! For 5 x 5 board, two tiles will be added every round if you are playing Powers of 2.",
                      @"Choose your favorite appearance and get your own feeling of 2048! More (and higher quality) themes are in the works so check back regularly!"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [GSTATE scoreBoardColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

#pragma table dateSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? 1 : _options.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section) {
        return @"";
    }
    return @"Please note: Changing the settings above would restart the game";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Setting Cell"];
    if (indexPath.section) {
        cell.textLabel.text = @"About 2048";
        cell.detailTextLabel.text = @"";
    } else {
        cell.textLabel.text = [_options objectAtIndex:indexPath.row];
        
        NSInteger index = [SETTING integerForKey:[_options objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [[_optionSelections objectAtIndex:indexPath.row] objectAtIndex:index];
        cell.detailTextLabel.textColor = [GSTATE scoreBoardColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        [self performSegueWithIdentifier:@"About Segue" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"Setting Detail Segue" sender:nil];
    }
}

#pragma mark - sugue 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Setting Detail Segue"]) {
        FJSettingDetailViewController *detail = segue.destinationViewController;
        
        NSInteger index = [_tableView indexPathForSelectedRow].row;
        detail.title = [_options objectAtIndex:index];
        detail.options = [_optionSelections objectAtIndex:index];
        detail.footer = [_optionsNotes objectAtIndex:index];
    }
}

@end




