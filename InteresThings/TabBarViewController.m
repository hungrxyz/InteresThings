//
//  TabBarViewController.m
//  InteresThings
//
//  Created by Žél Marko on 28/04/14.
//  Copyright (c) 2014 Dsoby. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()


@end


@implementation TabBarViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 2) {
        NSLog(@"Daj mi nekaj no");
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
        //[[self tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"gearTab"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
