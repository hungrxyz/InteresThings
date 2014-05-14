//
//  CameraViewController.h
//  InteresThings
//
//  Created by Žél Marko on 19/12/13.
//  Copyright (c) 2013 Dsoby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
{
    BOOL FrontCamera;
    BOOL haveImage;
}

@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) IBOutlet UIView *imagePreview;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage;

- (IBAction)snapImage:(id)sender;
- (IBAction)done:(id)sender;

@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

@end
