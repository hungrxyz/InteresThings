//
//  ExploreViewController.m
//  InteresThings
//
//  Created by Žél Marko on 18/12/13.
//  Copyright (c) 2013 Dsoby. All rights reserved.
//

#import "ExploreViewController.h"
#import "DetailExploreViewController.h"
#import "Detailish.h"

@interface ExploreViewController ()

@property (strong, nonatomic) PFGeoPoint *userLocation;


@end

@implementation ExploreViewController
{
    NSMutableArray *forDetail;
}


- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    forDetail = [[NSMutableArray alloc] init];
    [self getLocation];
}


- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}


- (void)getLocation
{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            self.userLocation = geoPoint;
            [self loadObjects];

            NSLog(@"userLocation: %f, %f", geoPoint.latitude, geoPoint.longitude);
        }
    }];
}


- (PFQuery *) queryForTable
{
    if (!self.userLocation) {
        return nil;
    }     
    PFQuery *query = [PFQuery queryWithClassName:@"HomePopulation"];
    [query whereKey:@"geopoint" nearGeoPoint:self.userLocation withinKilometers:15];
    
    query.limit = 25;

    [self getData];
    return query;
}


- (void)getData
{
    PFQuery *query = [PFQuery queryWithClassName:@"HomePopulation"];
    [query whereKey:@"geopoint" nearGeoPoint:self.userLocation withinKilometers:15];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                Detailish *detail = [Detailish new];
                detail.discovery = [object objectForKey:@"discovery"];
                PFFile *getImage = [object objectForKey:@"imageFile"];
                [getImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        detail.imagine = [UIImage imageWithData:data];
                        NSLog(@"Detail imagine: %@", detail.imagine);
                    }
                }];
                detail.location = [object objectForKey:@"location"];
                    
                [forDetail addObject:detail];
            }
        }
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleIdentifier = @"ExploreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleIdentifier];
    }
    
    cell.textLabel.text = [object objectForKey:@"discovery"];
    cell.detailTextLabel.text = [object objectForKey:@"location"];
    
    return cell;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        DetailExploreViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"Halo ej: %@", [forDetail objectAtIndex:indexPath.row]);
        destViewController.hump = [forDetail objectAtIndex:indexPath.row];
        destViewController.hidesBottomBarWhenPushed = YES;
        
        Detailish *details = [forDetail objectAtIndex:indexPath.row];
        NSLog(@"discovery: %@", details.discovery);
        NSLog(@"image: %@", details.imagine);
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
