//
//  PMComposePrayerRequestViewController.h
//  PrayMate
//
//  Created by zack on 10/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface PMComposePrayerRequestViewController : UIViewController<UITextViewDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    CLLocation *userLocation;
}
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)dogButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *dogImage;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)PFObject *group;
@property (strong, nonatomic)PFObject *prayer;
@property (weak, nonatomic) IBOutlet UIPickerView *groupsPickerView;
@property (strong, nonatomic)NSMutableArray *groupsArray;
@end
