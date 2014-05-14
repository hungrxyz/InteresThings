//
//  SettingsTableViewController.m
//  InteresThings
//
//  Created by Žél Marko on 01/05/14.
//  Copyright (c) 2014 Dsoby. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "LogInViewController.h"


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
    static NSString *cellIdentifier = @"staticCell";
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"Sign out";
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [PFUser logOut];
    
    LogInViewController *loger = [self.storyboard instantiateViewControllerWithIdentifier:@"logar"];
    [self presentViewController:loger animated:YES completion:nil];
}


@end
