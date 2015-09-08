//
//  PMEditPrayerViewController.h
//  PrayMate
//
//  Created by zack on 3/3/15.
//  Copyright (c) 2015 zachary hamblen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMEditPrayerViewController : UIViewController


@property (strong, nonatomic)PFObject *prayer;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;


@end
