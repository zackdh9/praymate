//
//  PMCreateGroupViewController.h
//  PrayMate
//
//  Created by zack on 11/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMCreateGroupViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextField *pinTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@end
