//
//  LogInViewController.m
//  InteresThings
//
//  Created by Žél Marko on 29/12/13.
//  Copyright (c) 2013 Dsoby. All rights reserved.
//

#import "LogInViewController.h"
#import "TabBarViewController.h"

@interface LogInViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *signUpLabel;

@end


@implementation LogInViewController


@synthesize usernameField, passwordField, signUpLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    signUpLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"logInButton.png"]];

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    usernameField.delegate = self;
    passwordField.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@", [PFUser currentUser]);
    if ([PFUser currentUser]) {
        TabBarViewController *homič = [self.storyboard instantiateViewControllerWithIdentifier:@"homič"];
        [self presentViewController:homič animated:NO completion:nil];
    }
}


- (IBAction)loginTapped:(id)sender 
{
    NSString *username = [usernameField text];
    NSString *password = [passwordField text];
    
    if (username.length < 5 || password.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoopsy daisy!" message:@"Username and Password must be at least 5 characters long." delegate:self cancelButtonTitle:@"I'll try again" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (user) {
                TabBarViewController *homič = [self.storyboard instantiateViewControllerWithIdentifier:@"homič"];
                [self presentViewController:homič animated:YES completion:nil];

            } else{
                NSLog(@"%@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:@"Invalid username or/and password" delegate:self cancelButtonTitle:@"Let me try again!" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
