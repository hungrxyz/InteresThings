//
//  CameraViewController.m
//  InteresThings
//
//  Created by Žél Marko on 19/12/13.
//  Copyright (c) 2013 Dsoby. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraViewController.h"
#import "UploadViewController.h"
#import "TabBarViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MBProgressHUD.h"



@interface CameraViewController ()
- (IBAction)back:(id)sender;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property double lat;
@property double lng;
@property (weak, nonatomic) IBOutlet UIImageView *snapView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *homičButton;
@property (weak, nonatomic) IBOutlet UIButton *librabyButton;


@end

@implementation CameraViewController

@synthesize stillImageOutput, imagePreview, captureImage, latitude, longitude;

- (void)viewDidLoad
{
    [super viewDidLoad];

    captureImage.hidden = YES;
    captureImage.clipsToBounds = YES;
    imagePreview.clipsToBounds = YES;
    
    self.snapView.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.snapView.layer.shadowOffset = CGSizeMake(0, 1);
    self.snapView.layer.shadowOpacity = 1.0f;
    
    self.doneButton.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.doneButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.doneButton.layer.shadowOpacity = 1.0f;

    self.homičButton.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.homičButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.homičButton.layer.shadowOpacity = 1.0f;

    self.librabyButton.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.librabyButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.librabyButton.layer.shadowOpacity = 1.0f;
}


- (IBAction)openLibrary:(id)sender
{
    haveImage = NO;
    [self showPhotoLibrary];
    [self snapImage:nil];
    
    self.captureImage.image = nil;
}


- (void) showPhotoLibrary
{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
    
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.captureImage.image = originalImage;
    
    NSLog(@"url %@",info);
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        // Get the asset url
        NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSLog(@"url %@",url);
        // We need to use blocks. This block will handle the ALAsset that's returned:
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            // Get the location property from the asset
            CLLocation *location = [myasset valueForProperty:ALAssetPropertyLocation];
            
            latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
            longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
            NSLog(@"\nLatitude: %f\nLongitude: %f",self.lat,self.lng);
        };

        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"Can not get asset - %@",[myerror localizedDescription]);
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:url
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    }
    

- (void)viewDidAppear:(BOOL)animated
{
    [self initializeCamera];
}


- (void) initializeCamera
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    captureVideoPreviewLayer.frame = self.imagePreview.bounds;
    [self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
        
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position: Back");
                backCamera = device;
            } else {
                NSLog(@"Device position: Front");
                frontCamera = device;
            }
        }
    }
    
    if (!FrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera; %@", error);
        }
        [session addInput:input];
    }
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
}


- (IBAction)snapImage:(id)sender
{
    if (!haveImage) {
        captureImage.image = nil;
        captureImage.hidden = NO;
        imagePreview.hidden = YES;
        [self capImage];
        [self getLocation];
        
    } else {
        captureImage.hidden = YES;
        imagePreview.hidden = NO;
        haveImage = NO;
    }
}


- (void) getLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    latitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude];
    longitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude];
    
    NSLog(@"Current location: %@, %@", self.latitude, self.longitude);
}


-(void) capImage
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"About to request capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo]  completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
           // [self processImage:[UIImage imageWithData:imageData]];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [captureImage setImage:image];
            haveImage = YES;
            //[[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
        }
    }];
}


- (IBAction)done:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    UploadViewController *image = [[UploadViewController alloc] init];
    image.theImage = captureImage.image;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"done"]) {
        UIImage *image = captureImage.image;
        UploadViewController *destViewController = segue.destinationViewController;
        destViewController.theImage = image;
        destViewController.hidesBottomBarWhenPushed = YES;
        
        destViewController.theLatitude = self.latitude;
        destViewController.theLongitude = self.longitude;
    }
}


- (BOOL) prefersStatusBarHidden
{
    return YES;
}


- (IBAction)back:(id)sender
{
    TabBarViewController *homič = [self.storyboard instantiateViewControllerWithIdentifier:@"homič"];
    [self presentViewController:homič animated:YES completion:nil];
    
}


@end
