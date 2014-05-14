//
//  UploadViewController.m
//  InteresThings
//
//  Created by Žél Marko on 19/04/14.
//  Copyright (c) 2014 Dsoby. All rights reserved.
//

#import "UploadViewController.h"
#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h> 
#import "MBProgressHUD.h"

@interface UploadViewController ()

- (IBAction)upload:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *discoveryTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *toCamera;
@property (weak, nonatomic) IBOutlet UIButton *upload;

@end


@implementation UploadViewController


@synthesize thingImageView, theImage, theLatitude, theLongitude, discoveryTextField, locationTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    discoveryTextField.delegate = self;
    thingImageView.image = theImage;
    NSLog(@"%@, %@", theLatitude, theLongitude);
    
    self.toCamera.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.toCamera.layer.shadowOffset = CGSizeMake(0, 1);
    self.toCamera.layer.shadowOpacity = 1.0f;
    
    self.upload.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.upload.layer.shadowOffset = CGSizeMake(0, 1);
    self.upload.layer.shadowOpacity = 1.0f;
    
    self.discoveryTextField.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.discoveryTextField.layer.shadowOffset = CGSizeMake(0, 1);
    self.discoveryTextField.layer.shadowOpacity = 1.0f;
    
    self.locationTextField.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.locationTextField.layer.shadowOffset = CGSizeMake(0, 1);
    self.locationTextField.layer.shadowOpacity = 1.0f;
}


- (IBAction)upload:(id)sender
{
    PFObject *thing = [PFObject objectWithClassName:@"HomePopulation"];
    [thing setObject:discoveryTextField.text forKey:@"discovery"];
    [thing setObject:locationTextField.text forKey:@"location"];
    
    PFObject *places = [PFObject objectWithClassName:@"Places"];
    [places setObject:locationTextField.text forKey:@"placeName"];
    
    NSData *imageData = UIImageJPEGRepresentation(thingImageView.image, 1.0);
    NSString *filename = [NSString stringWithFormat:@"ajde.png"];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [thing setObject:imageFile forKey:@"imageFile"];
    NSLog(@"%@", filename);
    
    PFGeoPoint *geo = [PFGeoPoint geoPointWithLatitude:[theLatitude doubleValue] longitude:[theLongitude doubleValue]];
    [thing setObject:geo forKey:@"geopoint"];
    [places setObject:geo forKey:@"geoCoo"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    [thing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully uploaded your InteresThing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
