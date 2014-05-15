//
//  HomeViewController.m
//  InteresThings
//
//  Created by Žél Marko on 18/12/13.
//  Copyright (c) 2013 Dsoby. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface HomeViewController ()


@end

@implementation HomeViewController



- (void)viewDidLoad
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"firstTime"] == NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Terms and Conditions" message:@"With a tap on the Accept button you accept the Terms and Conditions stated on this link: http://www.apple.com/legal/internet-services/itunes/appstore/dev/stdeula/." delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setValue:@"Not" forKey:@"firstTime"];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"superBar"] forBarMetrics:UIBarMetricsDefault];
    
    [self loadObjects];
}


-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName = @"HomePopulation"];
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    [query orderByDescending:@"createdAt"];
    
    return query;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 228;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"DiscoveryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    PFFile *backgroundImage = [object objectForKey:@"imageFile"];
    PFImageView *backgroundImageView = (PFImageView *) [cell viewWithTag:100];

    backgroundImageView.file = backgroundImage;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin);
    [backgroundImageView loadInBackground];

    UILabel *discoverLabel = (UILabel *) [cell viewWithTag:101];
    discoverLabel.text = [object objectForKey:@"discovery"];
    discoverLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:16.0];
    discoverLabel.textColor = [UIColor whiteColor];
    discoverLabel.shadowColor = [UIColor blackColor];
    discoverLabel.shadowOffset = CGSizeMake(1, 2);

    UILabel *locationLabel = (UILabel *) [cell viewWithTag:201];
    locationLabel.text = [object objectForKey:@"location"];
    locationLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:13.0];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.shadowColor = [UIColor blackColor];
    locationLabel.shadowOffset = CGSizeMake(1, 2);
 
    return cell;
}


- (IBAction)inappropriate:(id)sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    NSArray *arrrr = [[NSArray alloc] initWithObjects:@"m-4-rco@hotmail.com", nil];
    [controller setToRecipients:arrrr];
    [controller setSubject:@"Inappropriate Content Report!"];
    [controller setMessageBody:@"Inappropriate content with objectID:xAbCMrvND3." isHTML:NO];
    [self presentViewController:controller animated:YES completion:nil];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
