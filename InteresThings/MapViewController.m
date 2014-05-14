//
//  MapViewController.m
//  InteresThings
//
//  Created by Žél Marko on 08/01/14.
//  Copyright (c) 2014 Dsoby. All rights reserved.
//

#import "MapViewController.h"
#import "TabBarViewController.h"
#import "Annotation.h"


@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *theMap;

@property BOOL userLocationUpdated;

@end


@implementation MapViewController


@synthesize theMap, latitude, longitude;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.theMap.delegate = self;
    self.theMap.showsUserLocation = YES;
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        PFQuery *query = [PFQuery queryWithClassName: @"HomePopulation"];
        [query whereKey:@"geopoint" nearGeoPoint:geoPoint withinKilometers:1000];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                     PFGeoPoint *thePoint = [object objectForKey:@"geopoint"];
                    latitude = thePoint.latitude;
                    longitude = thePoint.longitude;
                    
                    NSLog(@" Hej %f, %f", latitude, longitude);
                    CLLocationCoordinate2D annotationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
                    Annotation *annotation = [[Annotation alloc] init];
                    annotation.coordinate = annotationCoordinate;
                    annotation.title = [object objectForKey:@"discovery"];
                    annotation.subtitle = [object objectForKey:@"location"];
                    annotation.objectID = object.objectId;
                    
                    [self.theMap addAnnotation:annotation];
                }
            }
        }];
    }];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.userLocationUpdated) {
        [self.theMap setCenterCoordinate:userLocation.location.coordinate];
        self.userLocationUpdated = YES;
    }
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"theLocation";
    if ([annotation isKindOfClass:[Annotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.theMap dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        //annotationView.canShowCallout = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-40, -100, 100, 100)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString *id = [(Annotation *)annotationView.annotation objectID];
        
        PFQuery *query = [PFQuery queryWithClassName:@"HomePopulation"];
        [query getObjectInBackgroundWithId:[NSString stringWithFormat:@"%@", id] block:^(PFObject *object, NSError *error) {
            PFFile *file = [object objectForKey:@"imageFile"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                imageView.image = [UIImage imageWithData:data];
            }];
        }];
        annotationView.image = [UIImage imageNamed:@"pointer"];
        [annotationView addSubview:imageView];
        
        return annotationView;
    }
    return nil;
}


- (BOOL) prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toXplorer:(id)sender
{
    TabBarViewController *Xplore = [self.storyboard instantiateViewControllerWithIdentifier:@"homič"];
    [Xplore setSelectedIndex:1];
    [self presentViewController:Xplore animated:YES completion:nil];
}


@end
