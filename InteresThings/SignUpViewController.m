//
//  SignUpViewController.m
//  InteresThings
//
//  Created by Žél Marko on 29/12/13.
//  Copyright (c) 2013 Dsoby. All rights reserved.
//

#import "SignUpViewController.h"
#import "LogInViewController.h"
#import "TabBarViewController.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;

@end


@implementation SignUpViewController


@synthesize usernameField, passwordField, emailField, locationField;


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
    
    usernameField.delegate = self;
    passwordField.delegate = self;
    emailField.delegate = self;
    locationField.delegate = self;
}


- (IBAction)signUpPressed:(id)sender
{
    NSString *user = usernameField.text;
    NSString *password = passwordField.text;
    NSString *email = emailField.text;
    NSString *location = locationField.text;
    
    if (user.length < 1 || password.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoopsy daisy!" message:@"Username has to be at least 1 characters long and password at least 6 characters." delegate:self cancelButtonTitle:@"Let me try again." otherButtonTitles:nil, nil];
        [alert show];
    } else if  (email.length < 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid entry." message:@"Enter your email address." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = user;
        newUser.password = password;
        newUser.email = email;
        newUser[@"location"] = location;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong with your registration" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"Verification mail has been sent to: %@. Verify your email and log in.", emailField.text] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
                [PFUser logOut];
            }
        }];
    }
}


- (IBAction)backToLogar:(id)sender
{
    LogInViewController *logar = [self.storyboard instantiateViewControllerWithIdentifier:@"logar"];
    [self presentViewController:logar animated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
