//
//  UploadViewController.h
//  InteresThings
//
//  Created by Žél Marko on 19/04/14.
//  Copyright (c) 2014 Dsoby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *thingImageView;
@property (weak, nonatomic) UIImage *theImage;
@property (strong, nonatomic) NSNumber *theLatitude;
@property (strong, nonatomic) NSNumber *theLongitude;

@end
