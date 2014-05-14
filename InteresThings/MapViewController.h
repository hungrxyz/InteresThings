//
//  MapViewController.h
//  InteresThings
//
//  Created by Žél Marko on 08/01/14.
//  Copyright (c) 2014 Dsoby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>


@interface MapViewController : UIViewController <MKMapViewDelegate>

@property double latitude;
@property double longitude;


@end
