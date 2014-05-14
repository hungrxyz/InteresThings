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




@end
