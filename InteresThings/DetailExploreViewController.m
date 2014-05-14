//
//  DetailExploreViewController.m
//  InteresThings
//
//  Created by Žél Marko on 01/05/14.
//  Copyright (c) 2014 Dsoby. All rights reserved.
//

#import "DetailExploreViewController.h"

@interface DetailExploreViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (weak, nonatomic) IBOutlet UIButton *xplore;
@property (weak, nonatomic) IBOutlet UILabel *locLabel;

@end


@implementation DetailExploreViewController


@synthesize theLabel, theImageView, xplore, locLabel;


- (void) viewWillAppear:(BOOL)animated
{
    theLabel.text = self.hump.discovery;
    theImageView.image = self.hump.imagine;
    locLabel.text = self.hump.location;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.xplore.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.xplore.layer.shadowOffset = CGSizeMake(0, 1);
    self.xplore.layer.shadowOpacity = 1.0f;
    
    theLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:20.0];
    theLabel.textColor = [UIColor whiteColor];
    theLabel.shadowColor = [UIColor blackColor];
    theLabel.shadowOffset = CGSizeMake(2, 2);
    
    locLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:18.0];
    locLabel.textColor = [UIColor whiteColor];
    locLabel.shadowColor = [UIColor blackColor];
    locLabel.shadowOffset = CGSizeMake(2, 2);
    locLabel.textAlignment = NSTextAlignmentRight;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) prefersStatusBarHidden
{
    return YES;
}


- (IBAction)toXplore:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
