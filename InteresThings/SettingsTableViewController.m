//
//  SettingsTableViewController.m
//  InteresThings
//
//  Created by Žél Marko on 01/05/14.
//  Copyright (c) 2014 Dsoby. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "LogInViewController.h"
#import "TermsAndConditionsViewController.h"


@interface SettingsTableViewController ()


@end


@implementation SettingsTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Sign out";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Terms and Conditions";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [PFUser logOut];
    
        LogInViewController *loger = [self.storyboard instantiateViewControllerWithIdentifier:@"logar"];
        [self presentViewController:loger animated:YES completion:nil];
    } else if (indexPath.section == 1) {
        TermsAndConditionsViewController *termič = [self.storyboard instantiateViewControllerWithIdentifier:@"termič"];
        [self presentViewController:termič animated:YES completion:nil];
    }
}


@end
